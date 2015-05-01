BEGIN {
FS=","
print "ENTRY_NO \tName\t\t\tCATEGORY\tSEX\t\tEMAIL";
}
 {
 	print $1 "\t\t" $2 "\t\t" $3 "\t" $4 "\t\tt" $5;
 }
 END{
 	print "Report Generated\n--------------";
 }