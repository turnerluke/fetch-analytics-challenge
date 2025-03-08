""" """

import json
import re
from pathlib import Path
from typing import Any, Dict, List, Type

import duckdb
import inflection
import polars as pl
from models import Brands, Receipts, Users
from pydantic import BaseModel, ValidationError

FILE_MODEL_MAPPING = {
    "users": Users,
    "brands": Brands,
    "receipts": Receipts,
}
PROJECT_ROOT = Path(__file__).parent.parent


def read_jsonl(file_path: Path) -> List[Dict[str, Any]]:
    """Read a JSONL (newline-delimited JSON) file."""
    with open(file_path, "r") as f:
        data = [json.loads(line) for line in f]
    return data


def to_snake_case(s: str) -> str:
    """Convert camelCase or PascalCase to snake_case."""
    name = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", s)
    name = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s)
    return name.lower()


def json_keys_to_snake_case_recursive(x):
    """Recursively convert dictionary keys to snake_case in dicts and lists."""
    if isinstance(x, dict):
        return {
            to_snake_case(k): json_keys_to_snake_case_recursive(v) for k, v in x.items()
        }
    elif isinstance(x, list):
        return [json_keys_to_snake_case_recursive(i) for i in x]
    return x


def validate_data(df: pl.DataFrame, model: Type[BaseModel]) -> List[dict]:
    """Validate rows in the dataframe against a Pydantic model."""
    validated_data = []
    for row in df.to_dicts():
        try:
            validated_data.append(model(**row).model_dump())
        except ValidationError as e:
            print(f"Validation error: {e}")
            raise e  # Stop execution on validation error
    return validated_data


def save_to_duckdb(
    table_name: str, data: List[dict], db_path=PROJECT_ROOT / "db.duckdb"
):
    """Save validated data to DuckDB."""
    conn = duckdb.connect(db_path)
    df = pl.DataFrame(data)
    conn.execute(f"CREATE TABLE IF NOT EXISTS {table_name} AS SELECT * FROM df")
    conn.close()


def process_file(file_path: Path, model: Type[BaseModel]):
    """Process a single JSON file: load, clean, validate, and store in DuckDB."""

    # Read file
    json = read_jsonl(file_path)

    # Convert colunms to snake_case
    json = json_keys_to_snake_case_recursive(json)

    # Create polars df
    df = pl.DataFrame(json)
    print(df.dtypes)

    # Check types
    validated_data = validate_data(df, model)

    # Write to duckdb
    table_name = file_path.stem  # Use file name (without .json) as table name
    save_to_duckdb(table_name, validated_data)


def main():
    """Main function to process all JSON files."""
    data_folder = Path(__file__).parent.parent / "data"
    for file_name, model in FILE_MODEL_MAPPING.items():
        file_path = data_folder / f"{file_name}.json"
        if file_path.exists():
            print(f"Processing {file_name}...")
            process_file(file_path, model)
        else:
            print(f"File {file_path} not found.")


if __name__ == "__main__":
    main()
