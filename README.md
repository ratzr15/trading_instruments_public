# Trading instruments app

Flutter application that displays a list of trading instruments along with a real-time price ticker to reflect price fluctuations.

### About

- Trading instruments app uses **CLEAN** with *layered architecture* for better maintainability and scalability.
- Trading instruments app's domain logics are unit tested & widget tested.
- Trading instruments app uses state management using bloc for better presentation isolation and management.

### Highlights

- Include golden tests
- Ensures type safety by enabling additional type [checks](https://dart.dev/language/type-system)
```yaml
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

### Code organization

```
--lib
   |--src
       |--data
       		|--datasource
       |--di
            |--provider
       |--domain
       		|--usecase
       |--presentation
       		|--trades-list
				
--packages
   |--core
   		|--api_client    
```

### Code coverage
![Screenshot 2024-09-17 at 3 59 44 PM](https://github.com/user-attachments/assets/8f9900df-127f-4807-8c91-d7de0a4d843c)

### Environment

```
  flutter: '3.24.1'
  dart: '3.5.1'
```

