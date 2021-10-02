---
title: cfbd_coaches
description: Coach information search 
 A coach search function which provides coaching records and school history for a given coach cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")
featured: true
topics: Coaches
recommended: null
---
# `cfbd_coaches`

CFBD Coaches Endpoint Overview


## Description

Coach information search 
 A coach search function which provides coaching records and school history for a given coach cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")


## Usage

```r
cfbd_coaches(
  first = NULL,
  last = NULL,
  team = NULL,
  year = NULL,
  min_year = NULL,
  max_year = NULL,
  verbose = FALSE
)
```


## Arguments

Argument      |Description
------------- |----------------
`first`     |     ( String optional): First name for the coach you are trying to look up
`last`     |     ( String optional): Last name for the coach you are trying to look up
`team`     |     ( String optional): Team - Select a valid team, D1 football
`year`     |     ( Integer optional): Year, 4 digit format ( YYYY ).
`min_year`     |     ( Integer optional): Minimum Year filter (inclusive), 4 digit format ( YYYY ).
`max_year`     |     ( Integer optional): Maximum Year filter (inclusive), 4 digit format ( YYYY )
`verbose`     |     Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function


## Value

Column      |Description
------------- |----------------
``     |     


## Examples

```r
cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")
```


