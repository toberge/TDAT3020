> be me  
> decompile binary  
> see oppurtunity for buffer overflow  
> think back to lecture  
> random gadgets? where's the flag then?  
> despair.m4a  
> spot a `print_flags` function  
> eureka.jpg  
> take the address  
> append it to a string  
> mess around with the thing for hours  
> it doesn't work  
> notice that what's passed is url-encoded _again_,  
> greeting me with "Hello AAAAAAAA%EE%06..."  
> ...  
> no python no more  
> `http://box/box/?stdin=AAAAA(...)AAAAA%ee%06%40%00%00%00%00%00`  
> finally done  
> relief.mp3
