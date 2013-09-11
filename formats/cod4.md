Call of Duty 4: Modern Warfare log file format documentation attempt
====================================================================

Each line represents a game event

Each line starts with timestamp.
Timer is reset with each new game session. Changing a map new InitGame event but does not reset the timer.

Game Events
-----------

Each game delimited with a string of dashes:

      0:00 ------------------------------------------------------------
    ...game events...
      0:59 ------------------------------------------------------------
     10:59 ------------------------------------------------------------
    ...other game events...
     21:58 ------------------------------------------------------------

### InitGame: {custom attributes}

Game start event

Custom commands are delimited by backslash `\` in form of `\attribute\value`, for example: `\g_gametype\war`

Commands are concatenated in one long string:

      0:00 InitGame: \g_compassShowEnemies\0\g_gametype\war\gamename\Call of Duty 4\mapname\mp_bloc\protocol\6\shortversion\1.7\sv_allowAnonymous\0\sv_disableClientConsole\0\sv_floodprotect\4\sv_hostname\CoD4Host\sv_maxclients\24\sv_maxPing\0\sv_maxRate\5000\sv_minPing\0\sv_privateClients\0\sv_punkbuster\1\sv_pure\1\sv_voice\0\ui_maxclients\32

### ShutdownGame: {?}

Final game shutdown event
 
### ExitLevel: {reason}

Current game level was exited because of `reason`

Known reasons: `executed`

Player Events
-------------

### J;{playerHash};{playerId};{playerName}

Player connect event
    
    0:59 J;82ceb3742e4cbd6cd0523fb6fa0973b7;1;nim579

For some reason player hosting the server is not assigned a hash

### Q;{playerHash};{playerId};{playerName}

Player disconnect event
     
     32:35 Q;7c67592b29746a89a5b6187d87592fbe;4;Kirill

Weapon Events
-----------

### Weapon;{playerHash};{playerId};{playerName};{weapon}

? Weapon or ammunition take event
    
     29:23 Weapon;c501fb2910ad96a55cd96923bcf49102;3;emuravjev;beretta_mp

Battle Events
-------------

Falling and other non-player inflicted damages and kills are made by team `world` with no player id or name

### K;{killerHash};{killerId};{killerTeam};{killerName};{victimHash};{victimId};{victimTeam};{victimName};{weapon};{damage};{damageMedium};{hitLocation}

Kill event

     29:26 K;c501fb2910ad96a55cd96923bcf49102;3;;emuravjev;8035fe74b5bf7aa6fea35f41a12c07b5;2;;kuteev;m16_gl_mp;70;MOD_HEAD_SHOT;head

### D;{attackerHash};{attackerId};{attackerTeam};{attackerName};{defendantHash};{defendantId};{defendantTeam};{defendantName};{weapon};{damage};{damageMedium};{hitLocation}

Damage event

     29:41 D;c501fb2910ad96a55cd96923bcf49102;3;allies;emuravjev;8035fe74b5bf7aa6fea35f41a12c07b5;2;axis;kuteev;m16_gl_mp;44;MOD_HEAD_SHOT;head

Chat events
-----------

###  say;{authorHash};{authorId};{authorName};{message}

     25:10 say;82ceb3742e4cbd6cd0523fb6fa0973b7;1;nim579;go

###  sayteam;{authorHash};{authorId};{authorName};{message} 

     20:53 sayteam;c501fb2910ad96a55cd96923bcf49102;2;emuravjev;sidi!!!     

