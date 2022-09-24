PROJECT 1


###################

The goal of this project is generate bitcoins with the required number of leading zeros using actor model. It has also been extended to enlist other machines to take part in bitcoin generation.

Steps to execute

Bitcoin mining using actor model Execute the following command in the directory where the project is present i) mix escript.build ii) ./project1 "number of required zeros" (4 can be substituted by any other number of required zeros)

Bitcoin mining using distributed implementation Execute the following command in the directory where the project is present in the SERVER machine i) mix escript.buil ii) ./project1 "number of required zeros" (4 can be substituted by any other number of required zeros)

Execute the following command in the directory where the project is present in the WORKER machine i) mix escript.build ii) ./project1 "ip address of server"

*NOTE : In order for a node to be a distributed node epmd (Erlang Port Mapper Daemon) must be running on the machine. If it isn't running then the node will not be able to start. To start epmd manually, execute "epmd -daemon" on command line.

Results

Size of work unit: Instead of assigning part of the mining process to each worker, each worker was assigned individual task of mining. In general, most computers have an average of 4 core. Hence, to optimize the mining process, on each request 8 processes were spawned on the worker.

The following output was obtained while mining for coins with 4 leading 0's.

raheenmz;/rQNgCPE 00008EEE5DC6632F700D7962344F6EE531728C999F1852A3A513716393077299 raheenmz;3DEhJA7e 0000BC2989DE94BCAC8C8694066E21E72AB289FEE0CDEB6A6FB653BC5FE17DD5 raheenmz;SxkkIBJT 0000318821E90EA6930A352B244DEF8E72A5B73309E64A80D59C6B14BF1D503A raheenmz;4liqtGas 0000E7F188B863157FC2277E5362BFB9AB7865E47D57723A1270F5AA350DFD79 raheenmz;G2Lft78a 00000F52C1C15DE3220A21E3D672E4D593A585DD00E1678CBC1D03069B7D4813 raheenmz;UJIPGtTo 00001790BC544B7A6D53DA0E90CC6D435A783E6843C616D127BB282FB12697D5 raheenmz;gLPBV7eQ 000024B72E511812392C90D182AA094B3E1DA33F58DB6675209F6682C6F77BB8 raheenmz;zebywgyg 000070371F39907A972E2C2428C737EA3EFA65040D811068F12B451C06F09F5C raheenmz;FO+PtMpl 00000835277AAD34E76F920514E94EE55E4748C231A5CF393A0D3698117D8A63 raheenmz;AM0WLBf9 00006B7A2D698D2A3BB64F87DFFD59271AFA986531D431812CB448B10FDFD0F3 raheenmz;KlBM+r/j 

CPU Time/Run Time: The following output was acheived on running the application on a 4 core machine.
lin114-09:117% time ./project1 5 raheenmz;jnDxI555 000003524438913BF7CCDFDD8A55AC69C3E0B102C3A4A1866C854694FA20F0B4 raheenmz;ysTpfo06 00000933D0ADE6B626C959996C01C81E8D704D55DE8462777D1FEC3931658655 30.244u 18.784s 0:12.97 377.9% 0+0k 0+0io 0pf+0w

CPU time: (Time in usermode) + (Time in kernel mode) = 49.028 Real time: 12.97

Ratio: 3.78

The program was able to mine coins with maximum 8 0's. Example of the coin and it's hash is raheenmz;DP2OBxGQ 00000000AF0D63E12AD88D09C03D1D1DBA38D11B243A03DF9BF98193FF75CD8F

Maximum number of machine/Nodes  : 3

Function description

I) Bitcoin_sup Contains functions for mining bitcoins on a single node using actor model.

i) start(k): Generates random string using "base64:encode(crypto:strong_rand_bytes(16)". Genrates hash of random string appended with UFID. Prints hash if it has atleast k leading zeros.

ii) check_value(hash, k, i): Verifies whether hash has atleast k leading zeros.

ii) spawn_mining(k) : Spawns mining process.

II) Server: Contains functions required to spawn process on worker nodes

i) server(k) : Creates a node and invokes function check_connection() to check for active connections.
   *NOTE : This function uses :inet.getif to obtain IP address of local machines. However, with this command position of local IP in result set is not fixed. Depending on it's position, we may have to used hd()/tl()/List.last() to get local IP. Currently hd() is being used.

ii) check_connection(k,list) : Continously monitors if any new nodes are connected to server. If new connections are found spawn_process is invoked.  

iii) spawn_process(temp_list,k) : Spawns process of list of nodes received as input. Input also includes number of zeros expected in bitcoin.
III) Worker: Contains functions to be run on worker nodes

i) worker(ip_address) : Creates a node and establishes connection with server node which is present on the IP address specified in the argument
*NOTE : This function uses :inet.getif to obtain IP address of local machines. However, with this command position of local IP in result set is not fixed. Depending on it's position, we may have to used hd()/tl()/List.last() to get local IP. Currently hd() is being used.


<img src="%20systemdesign.png" width="800" height="600">
