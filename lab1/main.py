from models import StoreLocation
from repository import MemoryRepository
import test_app

def main():
    repo = test_app.TestStoreRepository()
    repo.load_presete()

    art = """
    .--.      .--.    .-''-.    .---.        _______      ,-----.    ,---.    ,---.    .-''-.           _______      ____        _______   .--.   .--.   
    |  |_     |  |  .'_ _   \   | ,_|       /   __  \   .'  .-,  '.  |    \  /    |  .'_ _   \         \  ____  \  .'  __ `.    /   __  \  |  | _/  /    
    | _( )_   |  | / ( ` )   ',-./  )      | ,_/  \__) / ,-.|  \ _ \ |  ,  \/  ,  | / ( ` )   '        | |    \ | /   '  \  \  | ,_/  \__) | (`' ) /     
    |(_ o _)  |  |. (_ o _)  |\  '_ '`)  ,-./  )      ;  \  '_ /  | :|  |\_   /|  |. (_ o _)  |        | |____/ / |___|  /  |,-./  )       |(_ ()_)      
    | (_,_) \ |  ||  (_,_)___| > (_)  )  \  '_ '`)    |  _`,/ \ _/  ||  _( )_/ |  ||  (_,_)___|        |   _ _ '.    _.-`   |\  '_ '`)     | (_,_)   __  
    |  |/    \|  |'  \   .---.(  .  .-'   > (_)  )  __: (  '\_/ \   ;| (_ o _) |  |'  \   .---.        |  ( ' )  \.'   _    | > (_)  )  __ |  |\ \  |  | 
    |  '  /\  `  | \  `-'    / `-'`-'|___(  .  .-'_/  )\ `"/  \  ) / |  (_,_)  |  | \  `-'    /        | (_{;}_) ||  _( )_  |(  .  .-'_/  )|  | \ `'   / 
    |    /  \    |  \       /   |        \`-'`-'     /  '. \_/``".'  |  |      |  |  \       /         |  (_,_)  /\ (_ o _) / `-'`-'     / |  |  \    /  
    `---'    `---`   `'-..-'    `--------`  `._____.'     '-----'    '--'      '--'   `'-..-'          /_______.'  '.(_,_).'    `._____.'  `--'   `'-'   
                                                                                                                                                     """
    
    while True:
        print(art)
        print("\n---* SYSTEM OF STORES LOCATIONS *---")  
        print("1. Add store\n2. Show all\n3. Update\n4. Delete\n5. Exit")
        choice = input("Choose an action: ")

        if choice == '1':
            name = input("Name: ")
            addr = input("Address: ")
            city = input("City: ")
            repo.create(StoreLocation(0, name, addr, city))
            print("Saved")

        elif choice == '2':
            limit = 10
            offset = 0
            while True:
                stores = repo.get_all(offset, limit)
                if not stores: print("List are empty or ended."); break
                
                for s in stores:
                    print(f"ID: {s.id} | {s.name} | {s.city}, {s.address}")
                
                if input("Next page? (y/n): ") != 'y': break
                offset += limit

        elif choice == '3':
            idx = int(input("New id: "))
            new_name = input("New name (leave empty for skip): ")
            if new_name: repo.update(idx, {"name": new_name})
            print("Updated")

        elif choice == '4':
            idx = int(input("ID to delete: "))
            if repo.delete(idx): print("Deleted")
            else: print("Not found")

        elif choice == '5': break

if __name__ == "__main__":
    main()