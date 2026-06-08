# **CFBD API Key Endpoint Overview**

- [`cfbd_api_key_info()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md):
  Get information about your API key, including your Patreon level and
  usage limits.

- [`register_cfbd()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md):
  Save your API Key as a system environment variable `CFBD_API_KEY`.

- [`cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md):
  Retrieve the CFBD API key from the `CFBD_API_KEY` environment
  variable.

- [`has_cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md):
  Check whether a CFBD API key is registered in the current session.

## Details

### **Get information about your CFBD API key**

    cfbd_api_key_info()

### **Register / save your CFBD API key**

    Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")

### **Retrieve the CFBD API key**

    cfbd_key()

### **Check whether a CFBD API key is registered**

    has_cfbd_key()
