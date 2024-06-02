
## Redis CLI examples to load and use these funtions

### Load the functions

```bash
cat lock.lua | redis-cli -x FUNCTION LOAD
```

### Use the functions

```bash
FCALL lock 1 'rahul:lock' 12345 12000
```

```