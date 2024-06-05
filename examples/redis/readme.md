
## Redis CLI examples to load and use these funtions

### Load the functions

```bash
cat lock.lua | redis-cli -x FUNCTION LOAD
```

### Use the functions


```bash
FCALL lock 1 'rahul:lock' 12345 12000
```


### Attempted to use modules for library functions
Redis does not allow executing require in their lua environment. 
This limits us to using a single file for all our functions. 
Unless we can find something meaning full. 
Other wise we can find a way to combine them all at load time.

```bash
cat lock.lua | redis-cli -x FUNCTION LOAD REPLACE
cat queue.lua | redis-cli -x FUNCTION LOAD REPLACE
cat operationFactory.lua | redis-cli -x FUNCTION LOAD REPLACE
```

```
> FCALL testfunc 0 testlockscope
"Hello From Lock Lib"
```

```
> FCALL testfunc 0 testoperation
"ERR user_function:19: Script attempted to access nonexistent global variable 'testoperation' script: testfunc, on @user_function:19."
```

### 

This is an advisory locking mechanism. It is the clients responsibility to respect the locks states if they deem suitable.
The lock itself does not carry information about the entity being locked. 
This can be conveyed by clients in multiple ways:
One of the ways would be to use lock key itself as the entity being locked.
    - An example would be to name the key as : `lock:entity1`

