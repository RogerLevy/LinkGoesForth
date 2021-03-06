0.15 constant walk_anim_speed
var olddir
rolevar walkanims
rolevar spd
basis{ 1.5 spd ! }
action idle
action walk
defrole avatar

: dirkeys?  left? right? up? down? or or or ;
: ?face
    dir @ olddir @ <> if
        dir @ olddir !
        walkanims @ -exit
        walkanims @ dir @ [] @ execute
    then 
;
: !walkv   walkv dir @ 2 * [] 2@  spd @ dup 2*  vx 2! ;
: ?walk    dirkeys? -exit  !walkv  ?face  walk ;

: ?turnstop
    dirkeys? 0= if  idle exit then
    <left> released  <right> released or  <up> released or  <down> released or
        if  sudlr4  else  pudlr4  then  ?walk ;

avatar :to walk  walk_anim_speed anmspd !  act>  ?turnstop ;
avatar :to idle  -vel  ?face  0 anmspd !  act>  pudlr4  ?walk ;
