<h3>BitcoinMiner Hashing</h3> <br/>


The goal of this project is generate bitcoins with the required number of leading zeros using actor model.
- Created a distributed bitcoin hashing application based on the Erlang actor model, in which 100 actors distributed over three nodes and hashed bitcoin strings using SHA256 cryptographic hash function.

<h4>Steps to execute :</h4><br/>
<pre>
Steps 1:
1. Supervisor - 
-Give name to supervisor along setting the cookie:
  erl -name akash@{ipaddress} -setcookie {cookiename}
2. Client -
-Give name to supervisor along setting the cookie:
 erl -name akash@{ipaddress} -setcookie {cookiename} #same cookie name
<br/>
Steps 2:
1. Supervisor-
- Compile and Call the start method - 
 c(bitcoinMiner_sup).
 bitcoinMiner_sup:start(K).  # K = number of leadaing zeros
2. Client-
- Compile and Call the start method - 
 c(bitcoinMiner_sup).
 bitcoinMiner_sup:start({host name}).
 hostname : akash@{ipaddress}
</pre>

<h4>Results</h4>

The following output was obtained while mining for coins with 4 leading 0's.
<pre>
akashkumar;/rQNgCPE 00008EEE5DC6632F700D7962344F6EE531728C999F1852A3A513716393077299 <br/>akashkumar;3DEhJA7e 0000BC2989DE94BCAC8C8694066E21E72AB289FEE0CDEB6A6FB653BC5FE17DD5 <br/>akashkumar;SxkkIBJT 0000318821E90EA6930A352B244DEF8E72A5B73309E64A80D59C6B14BF1D503A <br/>akashkumar;4liqtGas 0000E7F188B863157FC2277E5362BFB9AB7865E47D57723A1270F5AA350DFD79 <br/>akashkumar;G2Lft78a 00000F52C1C15DE3220A21E3D672E4D593A585DD00E1678CBC1D03069B7D4813 <br/>akashkumar;UJIPGtTo 00001790BC544B7A6D53DA0E90CC6D435A783E6843C616D127BB282FB12697D5 <br/>akashkumar;gLPBV7eQ 000024B72E511812392C90D182AA094B3E1DA33F58DB6675209F6682C6F77BB8 <br/>akashkumarzebywgyg 000070371F39907A972E2C2428C737EA3EFA65040D811068F12B451C06F09F5C <br/>akashkumar;FO+PtMpl 00000835277AAD34E76F920514E94EE55E4748C231A5CF393A0D3698117D8A63 <br/>akashkumar;AM0WLBf9 00006B7A2D698D2A3BB64F87DFFD59271AFA986531D431812CB448B10FDFD0F3
</pre>
<h4>Statistics</h4><pre>
CPU time: (Time in usermode) + (Time in kernel mode) = 30.028 Real time: 8.97
Maximum number of machine/Nodes  : 3
Maximum numbe of Actor user: 3 * 100
</pre>

<h4>Files description</h4>
<pre>
1) bitcoin_app Contains functions for mining bitcoins on a single node using actor model.
2) bitcoin_sup Contains functions for supervising the 3 node by sending K value.
</pre>
<h4>System Design for the project:</h4>
<img src="%20systemdesign.png" width="800" height="600">
