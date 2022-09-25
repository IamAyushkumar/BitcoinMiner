<h3>BitcoinMiner Hashing</h3> <br/>

The goal of this project is generate bitcoins with the required number of leading zeros using Erlang actor model.
- Created a distributed bitcoin mining application based on the Erlang actor model, in which multiple actors distributed over three client nodes generates hashed bitcoin strings and compares the number of leading zeroes in their SHA256 cryptographic hash function.

<h4>Steps to execute :</h4><br/>
<pre>
Steps 1:
1. Sever - 
- Give name to the server along with the cookie:
  erl -name akash@{ipaddress} -setcookie {cookiename}
2. Client Supervisor-
- Give name to client along with the cookie:
 erl -name akash@{ipaddress} -setcookie {cookiename} #same cookie name
<br/>
Steps 2:
1. Sever -
- Compile and Call the start method - 
 c(bitcoinMinerServer).
 bitcoinMinerServer:start(MinNumberOfLeadingZeros). 
2. Client Supervisor-
- Compile and Call the start_link method - 
 c(bitcoinMinerClientNodeSup).
 bitcoinMinerClientNodeSup:start_link({host name}).
 eg. hostname : akash@{ipaddress}
</pre>

<h4>Results</h4>

The following output was obtained while mining for coins with 4 leading 0's.
<pre>
ayushakash;UiJIqcFRxv	00009F55CE0B802B501262AB232963077E360E4C199E5FE6DEBD4D6E95E56184
ayushakash;0wIcAotXuc	00008CFA67969B41829EBC5E68DA3A6921B0742185F23841F634002BB81BE7AC
ayushakash;6e1wk9QKzW	0000E5BAA2E5F4BDB4A6BC74A52D8526DBEF5F8C6CCBD1FD33E0E33ED1B1F4CB
ayushakash;HBqER5J5pS	0000F4FAA0C16DC2F5BBB72FCAE2CDEE8F809DB25E543849FCAE58DDFF5568A7
ayushakash;nV3cTKVg2w	0000CF441927A90824FC7E850D272F7BA28130B08C5D152EAA2F8322F0337248
ayushakash;KDc9gdYDOu	0000482F2E28ECC0D5B711B18870B227206C657F43E8866E73F831F06AFC921E
ayushakash;gtRYqpROx2	000016127649262A9A9481E9EA9D947AD75B3CEDCA47FCAC6A6D0A2676F550F7
ayushakash;q8gmwKhVnR	0000B6D43C354E0DC4149F54DCD2EA264EE9FA5FEEE0A9C45F73C83DEAB4FCDF
ayushakash;eLw0m5DTjF	0000C301D16ACEDD63400EBE3B8AFE6D582941285AEFFBB9D52A61CA4D25A124
ayushakash;SrZUWeOuGK	000019AA1DA4B7237BC16E93FAC50E5B9008F11F28426B4223C774CA4633D516
ayushakash;WiRgrnUDjo	0000903C03F46074596F2989B642AECC1D46AA8591807F43680D6BCC1DE20EA4
ayushakash;tAo0NV0Tn2	0000D7C9C55EE82B7DE84D97F4A7BD382A6A2EA6F35FCD7C7BD3C27199F37C83
ayushakash;wvB2ADbSYl	00007322C3450AFE97D2BDED7F77C68DCB2EF191EBBFF5CB2EB29F111C6793A5
ayushakash;KXhzvHp7nE	0000D2F4549C29C4845D3EE99813863A05B9101458E8F746A826721BE072AC09
ayushakash;4kpyyXmyWx	000015E9DE8D93C463114EADCD00DA43DC0F76E5AD249A2CF237086713FA1305
ayushakash;IIOfiSwmWQ	000099AF9A45B574EA18B214DE6CB32789B4F9B3F2B597E452158DA3386F2E00
ayushakash;Lm1BhgQWyk	0000554926653A8527D919AB81F9851D678F558732DAE53CA9BE7BD580936FFB
ayushakash;oi4kn97OFp	000045CD5F6B5B645C964F5CDC5E2DD4316980E4A185995166CAFB1EE4816050
ayushakash;DAntNuFAmV	000049261AFDE12F117B7B8FE3552B0EFA5A2460D81C246962A39CC22581F0F8
ayushakash;NbIpbLNCzc	00006309A136FFC7F593739FB962C54DE138F1848837DD6B240AF2EEFF229067
ayushakash;Pm2aztv2nb	000096C7AD53318124C1F961AECB4A366DFD68E41565945674350D1085C21641
ayushakash;eYcSptODIz	0000085FC0A71268FEC472C471B4002951E2ACABE3C4C186294A73A87A205A63
ayushakash;XyNQthVZow	0000AB11194DCC69776836FA1D4554DB30F4C8C84A434B59239CF15ADA7C73B4
ayushakash;8Qo4q1wSsS	0000D1A4347102CAE6D3B37AD79B0A589965555477C23D33FF07EBC2AABEE060
</pre>
<h4>Coin with most zeroes</h4>
<pre>
ayushakash;Yl3dEYbrLP	00000004A7C52E2AF1A1BA7D992BE69A120C6D1C4EE408F0DACB1F23F9171E09
</pre>

<h4>Statistics</h4><pre>
CPU time: (Time in usermode) + (Time in kernel mode) = 30.028 Real time: 8.97
Maximum number of machine/Nodes  : 3
Maximum numbe of Actor user: 3 * 500
</pre>

<h4>Files description</h4>
<pre> 
1) bitcoinMinerServer Contains functions for starting the 3 client nodes by sending start processing message
with{minleadingzeros} value.
2) bitcoinMinerClientNodeSup Contains functions to spawn 500 actors and supervises them on a single node using
actor model.
3) bitcoinMinerClientActor/bitcoinMinerActorProcess: These files contains the core business logic of mining 
bitcoin methods. bitcoinMinerClientActor spawns the logic process and also calls the start_link method of 
bitcoinminerActorProcess method upon recieving the message from parent node. bitcoinMinerActorProcess responsible
to generate the hashed strings with SHA256 by concating the gatorlink Id with random string and chevks for the 
leading zeros. Upon finding the required numbe of zeros. It sends a message back to client node supervisor 
which inturn relays the message the "foundCoin" message to the Server.
4) calstatsScheduler Contains function to start the CPU times.
</pre>
<h4>System Design for the project:</h4>
<img src="%20systemdesign.png" width="800" height="600">

<H3> Authors </H3>
<pre>
Ayush Kumar (ayushkumar@ufl.edu) <br/>
Akash Kumar (akashkumar@ufl.edu)
</pre>
