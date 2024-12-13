
# jtfRms

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/duboisa7/jtfRms/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/duboisa7/jtfRms/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

jtfRms is a JotForm API wrapper, enabling a quick and simple method to pull JotForm data into R. 

This package was initially created to address my need for pulling specific JotForm data into tidy data frames but I plan to add additional functionality in future versions.

## Installation

You can install the development version of jtfRms from [GitHub](https://github.com/) with:

``` r

# install.packages("devtools")
devtools::install_github("duboisa7/jtfRms")

```

## Getting Started

An API key is required to use the JotForm API. An API key can easily be created by going to [My Account](https://www.jotform.com/myaccount/api) --> "API" --> "Create New Key". 
See [JotForm API Overview](https://api.jotform.com/docs/#overview) on the JotForm website for more details.

``` r
library(jtfRms)

# Store JotForm API key
set_key("123")

# Check if you have a JotForm API key stored
get_key()

```

## Creating a request

The JotForm API has three default base URLs: their standard base URL, one for EU users, and one for access HIPAA-compliant data. jtfRms doesn't currently have the functionality to connect to the JotForm API using Enterprise custom URLs.

Currently, jtfRms can create a few basic GET requests:

1. Request a list of forms created by the user
2. Request form properties of a specific form
3. Request submission data of a specific form

These requests return an HTML response object. 

```r

# Request forms created by user. 
# JotForm's default limit returns up to 20 forms; adjust this using the `limit` argument.

request <- create_request(url_type = "standard", request_type = "form_list", limit = 50)

# Request form property data on a single form
# The form ID is required for this type of request. The form ID is the string of numbers at the end of the form URL. They can also be found by performing a request using request_type = "form_list" and parsing the response.
request <- create_request(url_type = "standard", form_id = "1234567", request_type = "form")

# Request submission data from a form
# The form ID is required for this type of request. The form ID is the string of numbers at the end of the form URL. They can also be found by performing the request using request_type = "form_list" and parsing the response.
# JotForm defaults to returning data on 20 submissions; this can be adjusted using the `limit` argument.
request <- create_request(url_type = "standard", form_id = "1234567", request_type = "form", limit = 100)

```

## Extracting data

The body of the response created via create_request() contains the relevant JotForm data.

The [httr2 package](https://CRAN.R-project.org/package=httr2) offers great functions for extracting the response body into raw bytes, UTF-8 string, parsed JSON, parsed HTML, or parsed XML.

Use `jtfRms::parse_to_df()` to create a super simple data frame of the parsed response data.

```r

# Create a submission data request
request <- create_request(url_type = "standard", form_id = "1234567",request_type = "form",limit = 100)

# Create a data frame of the form submission data
df <- parse_to_df(request = request,type = "submissions")

```


