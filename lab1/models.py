from dataclasses import dataclass

@dataclass
class StoreLocation:
    id: int
    name: str
    address: str
    city: str
    is_open: bool = True
    ratinhg: float
