cr .( Loading engine... ) \ "
include afkit/ans/depend.f
depend ramen/ramen.f
#1 #8 #1 [ramen] [checkver]
depend ramen/stdpack.f

65536 2 * constant #MAXTILES   \ need to define this here not at the top otherwise it'll be decimal

depend ramen/lib/tiled.f
depend ramen/lib/buffer2d.f
depend engine/lib/kbfocus.f
include engine/variables.f
include engine/loop.f
include engine/util.f
include engine/world.f
depend engine/lib/actor.f
depend engine/lib/tools.f

: !pos  ( gid )
    mbh @ negate y +!
    ( gid ) tsize drop 2 /  mbw @ 2 / - x +! ;

0 value mapdat

:is tmxobj   ( object-nnn role -- )
    swap to mapdat 
    's recipe @ execute
    mapdat gid@ !pos ;
:is tmxrect  ( object-nnn w h -- ) 3drop ;
:is tmximage ( object-nnn gid -- ) 2drop ;

: rolecall  s" Objects" find-objgroup load-objects ;

0 value items-gid

: loadtilemap
    s" data/world.tmx" open-map
    0 tmxlayer tilebuf0 0 0 load-tmxlayer
    1 tmxlayer tilebuf1 0 0 load-tmxlayer
    s" bg.tsx" find-tileset# load-tileset
    s" items.tsx" find-tileset#
        dup load-tileset
        tileset-gid to items-gid
;

: loadmap
    loadtilemap
    actors none rolecall
;

