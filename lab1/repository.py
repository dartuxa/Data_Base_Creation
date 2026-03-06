from abc import ABC, abstractmethod
from typing import List, Optional
from models import StoreLocation

class IRepository(ABC):
    @abstractmethod
    def create(self, entity: StoreLocation) -> None: pass
    
    @abstractmethod
    def get_all(self, offset: int = 0, limit: int = 10) -> List[StoreLocation]: pass
    
    @abstractmethod
    def update(self, entity_id: int, new_data: dict) -> bool: pass
    
    @abstractmethod
    def delete(self, entity_id: int) -> bool: pass

class MemoryRepository(IRepository):
    def __init__(self):
        self._storage = {}
        self._current_id = 1

    def create(self, entity: StoreLocation):
        entity.id = self._current_id
        self._storage[self._current_id] = entity
        self._current_id += 1

    def get_all(self, offset: int = 0, limit: int = 10) -> List[StoreLocation]:
        data = list(self._storage.values())
        return data[offset : offset + limit]

    def update(self, entity_id: int, new_data: dict) -> bool:
        if entity_id in self._storage:
            entity = self._storage[entity_id]
            for key, value in new_data.items():
                if hasattr(entity, key):
                    setattr(entity, key, value)
            return True
        return False

    def delete(self, entity_id: int) -> bool:
        return self._storage.pop(entity_id, None) is not None