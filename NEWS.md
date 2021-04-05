# cfbfastR 1.0.0

### **v1.0.0**

#### Function Naming Convention Change 

* All functions sourced from the College Football Data API will start with `cfbd_` as opposed to `cfb_` (as in cfbscrapR). 

* Similarly, data and metrics sourced from ESPN will begin with `espn_` as opposed to `cfb_`. In particular, the two functions are now [```espn_ratings_fpi()```](https://saiemgilani.github.io/cfbfastR/reference/espn_ratings.html) and [```espn_metrics_wp()```](https://saiemgilani.github.io/cfbfastR/reference/espn_metrics.html)

* Data generated from any of the ```cfbfastR``` methods will use `cfb_`

#### College Football Data API Keys

The [CollegeFootballData API](https://collegefootballdata.com/) now requires an API key, here's a quick run-down:

* To get an API key, follow the directions here: [College Football Data Key Registration.](https://collegefootballdata.com/key) 

* Using the key: At the beginning of every session or within an R environment, save your API key as the environment variable `CFBD_API_KEY` using a command like the following.

```{r}
Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

* Added [API Key methods](https://saiemgilani.github.io/cfbfastR/reference/register_cfbd.html). If you forget to set your environment variable, functions will give you a warning and ask for one. 