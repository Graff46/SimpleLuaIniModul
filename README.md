# SimpleLuaIniModul
 [English](#en)
Simple module for parsing files in ini format into a lua table and write files in the ini format from a table in lua.
***
The parsing of the file: call the function parse(file, comm), pfile - the file name (string), comm - record comments to a table (true\false).
Function returns table with data from ini file.
***
Write data to ini file - to do this, call function write(tbl, pfile, mode), tbl - table with data, pfile - path to the file to be created, mode-write type to the file (as in lua io.open (fileName, mode).
Functon returns a string in ini format, if you not use file path, else returns handle of the created file and a string in ini format.
***
The format of the table get written to the ini:
```
local table = {
    sectionName1 = {
        [";"] = "comment1",
        key1 = value1,
        key2 = {value2, [";"] = "comment2"},
        value3,
        {value4, [";"] = "comment3"}
        }
}
```
>The table key [;] contains comments if you set the required parameter in the parsing function to true. You need to create such keys in the table that would be when writing the file comments 
>
INI: 
```
[sectionName1]; comment1
key1 = value1
key2 = value2; comment2
value3
value4; comment3
```
***
example code
parsing:
```
local a = parsing("C:\\MyTest.ini", true)
print(a.section.key)
```
write:
```
local t = {
    section1 = {
        key = val,
        key2 = {val2, [";"] = "comment"}
    },
    section2 = {
        [';'] = "comment for section2",
        key = val,
        val2, 
        {val3, [";"] = "new comment"}
    }
}
-- write ini in file
local a, b = write(t, "C:\\NewIniFile.ini")
-- a - string in format ini
-- b - handle of the created file
```
