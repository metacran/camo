


# camo

Proof of concept, to load multiple versions of the same R package at once.

## Testing

We install two versions of the same package, in temporary
directories. Temporary directories first.


```r
library(camo)
library(magrittr)
tmp1 <- tempfile() 
tmp2 <- tempfile()
dir.create(tmp1)
dir.create(tmp2)
```

Install the first version into `tmp1`.


```r
.libPaths(tmp1)
install.packages("DBI", type = "source")
```

```
## Installing package into '/private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/RtmpEGYT5G/file93e144282d3c'
## (as 'lib' is unspecified)
```

```
## 
## The downloaded source packages are in
## 	'/private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/RtmpEGYT5G/downloaded_packages'
```

Install the second version into `tmp2`.


```r
.libPaths(tmp2)
install.packages("http://cran.rstudio.com/src/contrib/Archive/DBI/DBI_0.2-7.tar.gz",
	repos=NULL, type="source")
```

```
## Installing package into '/private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/RtmpEGYT5G/file93e129b1e119'
## (as 'lib' is unspecified)
```

Now add both temporary directories to the search path, and see what
versions we have.


```r
.libPaths(c(tmp1, tmp2))
package_versions("DBI")
```

```
##                                                                                    dir
## 1 /private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/RtmpEGYT5G/file93e144282d3c
## 2 /private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/RtmpEGYT5G/file93e129b1e119
## 3                       /Library/Frameworks/R.framework/Versions/3.1/Resources/library
##   version
## 1   0.3.0
## 2   0.2-7
## 3   0.2-7
```

Load both versions.


```r
camo("DBI", "0.2-7")
```

```
## <environment: namespace:DBI@0.2-7>
```

```r
camo("DBI", "0.3.0")
```

```
## <environment: namespace:DBI@0.3.0>
```

```r
loadedNamespaces() %>% grep(pattern = "^DBI", value = TRUE)
```

```
## [1] "DBI"       "DBI@0.2-7" "DBI@0.3.0"
```

See the functions in both versions.


```r
ls(asNamespace("DBI@0.3.0"))
```

```
##  [1] "compliance_message"    "dbBegin"              
##  [3] "dbCallProc"            "dbClearResult"        
##  [5] "dbColumnInfo"          "dbCommit"             
##  [7] "dbConnect"             "dbDataType"           
##  [9] "dbDisconnect"          "dbDriver"             
## [11] "dbExistsTable"         "dbFetch"              
## [13] "dbGetDBIVersion"       "dbGetException"       
## [15] "dbGetInfo"             "dbGetQuery"           
## [17] "dbGetRowCount"         "dbGetRowsAffected"    
## [19] "dbGetStatement"        "dbHasCompleted"       
## [21] "dbi_dep"               "dbiCheckCompliance"   
## [23] "dbiDataType"           "dbIsValid"            
## [25] "dbListConnections"     "dbListFields"         
## [27] "dbListResults"         "dbListTables"         
## [29] "dbQuoteIdentifier"     "dbQuoteString"        
## [31] "dbReadTable"           "dbRemoveTable"        
## [33] "dbRollback"            "dbSendQuery"          
## [35] "dbSetDataMappings"     "dbUnloadDriver"       
## [37] "dbWriteTable"          "fetch"                
## [39] "findDriver"            "get2"                 
## [41] "has_methods"           "is_attached"          
## [43] "isSQLKeyword"          "isSQLKeyword.default" 
## [45] "key_methods"           "make.db.names"        
## [47] "make.db.names.default" "print.list.pairs"     
## [49] "SQL"                   "SQLKeywords"          
## [51] "summary"               "varchar"
```

```r
ls(asNamespace("DBI@0.2-7"))
```

```
##  [1] "dbCallProc"            "dbClearResult"        
##  [3] "dbColumnInfo"          "dbCommit"             
##  [5] "dbConnect"             "dbDataType"           
##  [7] "dbDataType.default"    "dbDisconnect"         
##  [9] "dbDriver"              "dbExistsTable"        
## [11] "dbGetDBIVersion"       "dbGetException"       
## [13] "dbGetInfo"             "dbGetQuery"           
## [15] "dbGetRowCount"         "dbGetRowsAffected"    
## [17] "dbGetStatement"        "dbHasCompleted"       
## [19] "dbListConnections"     "dbListFields"         
## [21] "dbListResults"         "dbListTables"         
## [23] "dbReadTable"           "dbRemoveTable"        
## [25] "dbRollback"            "dbSendQuery"          
## [27] "dbSetDataMappings"     "dbUnloadDriver"       
## [29] "dbWriteTable"          "fetch"                
## [31] "isSQLKeyword"          "isSQLKeyword.default" 
## [33] "make.db.names"         "make.db.names.default"
## [35] "print.list.pairs"      "SQLKeywords"          
## [37] "summary"
```
