from repository import MemoryRepository
from models import StoreLocation

class TestStoreRepository:
    def __init__(self):
        self.repo = MemoryRepository()
    
    def load_presete(self):
        self.repo.create(StoreLocation(0, "ATB", "st. Biblika 12", "Kharkiv"))
        self.repo.create(StoreLocation(0, "Tavriya V", "pr. Aerokosmichniy 47", "Kharkiv"))
        self.repo.create(StoreLocation(0, "Ovoshnoy", "st. Darbinyana 10", "Korostyshiv"))
    
    def create(self, entity):
        self.repo.create(entity)
    
    def get_all(self, offset=0, limit=10):
        return self.repo.get_all(offset, limit)
    
    def update(self, entity_id, new_data):
        return self.repo.update(entity_id, new_data)
    
    def delete(self, entity_id):
        return self.repo.delete(entity_id)