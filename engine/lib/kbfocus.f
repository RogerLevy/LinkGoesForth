\ transparent keyboard focus for LinkGoesForth
\ objects are given an KEYGROUP rolevar that points to a keygroup (just a bitmask variable)
\ to give different objgroups input focus, just change the corresponding bitmask in the Keygroup.
\ by default every object's keygroup is #0.

\ an additional table called KEYDEFS defines the keygroup of each key.

\ KEYDEFS is to be considered abstract.  but it happens to be mapped directly to the keyboard, for now.
\ (I'll add joystick at some point)

\ we redefine keyboard input words to transparently lookup the keygroup 's bitmask and AND it with
\ the corresponding value from KEYDEFS before looking up the actual key.
\ if the object's keygroup does not have focus, force it to always return 0.    

#1
    bit KEYS_NAV    \ includes arrowkeys, enter, esc, tab, backspace, and delete
    bit KEYS_ACTION \ q w e r a s d f z x c v
    bit KEYS_QWERTY \ all the a-z keys
    bit KEYS_NUM    \ all the number keys 
    bit KEYS_PUNCT  \ - = [ ] \ ; ' , . /
    bit KEYS_FUNC   \ function keys
value LAST_KEYDEF

rolevar keygroup

\ keygroupdef ( -- <name> ) ( -- bitmask-adr )
: keygroupdef  create $ffffffff , ;

keygroupdef default-keygroup 
create keydefs  256 stack

\ my-keygroup  ( -- bitmask-adr )
: my-keygroup  keygroup @ ?dup ?exit  default-keygroup ;

: keydef!  swap 1p keydefs nth ! ;
: keydef@  1p keydefs nth @ ;

    <left>  KEYS_NAV keydef!
    <right> KEYS_NAV keydef!
    <up>    KEYS_NAV keydef!
    <down>  KEYS_NAV keydef!
    <enter> KEYS_NAV keydef!
    <esc>   KEYS_NAV keydef!
    <tab>   KEYS_NAV keydef!
    <bksp>  KEYS_NAV keydef!
    <del>   KEYS_NAV keydef!
    
    <q> KEYS_ACTION keydef!
    <w> KEYS_ACTION keydef!
    <e> KEYS_ACTION keydef!
    <r> KEYS_ACTION keydef!
    <a> KEYS_ACTION keydef!
    <s> KEYS_ACTION keydef!
    <d> KEYS_ACTION keydef!
    <f> KEYS_ACTION keydef!
    <z> KEYS_ACTION keydef!
    <x> KEYS_ACTION keydef!
    <c> KEYS_ACTION keydef!
    <v> KEYS_ACTION keydef!

    <1> KEYS_NUM keydef!
    <2> KEYS_NUM keydef!
    <3> KEYS_NUM keydef!
    <4> KEYS_NUM keydef!
    <5> KEYS_NUM keydef!
    <6> KEYS_NUM keydef!
    <7> KEYS_NUM keydef!
    <8> KEYS_NUM keydef!
    <9> KEYS_NUM keydef!
    <0> KEYS_NUM keydef!

    <-> KEYS_PUNCT keydef!
    <=> KEYS_PUNCT keydef!
    <[> KEYS_PUNCT keydef!
    <]> KEYS_PUNCT keydef!
    <backslash> KEYS_PUNCT keydef!
    <;> KEYS_PUNCT keydef!
    <'> KEYS_PUNCT keydef!
    <,> KEYS_PUNCT keydef!
    <.> KEYS_PUNCT keydef!
    </> KEYS_PUNCT keydef!
    
    <F1> KEYS_FUNC keydef!
    <F2> KEYS_FUNC keydef!
    <F3> KEYS_FUNC keydef!
    <F4> KEYS_FUNC keydef!
    <F5> KEYS_FUNC keydef!
    <F6> KEYS_FUNC keydef!
    <F7> KEYS_FUNC keydef!
    <F8> KEYS_FUNC keydef!
    <F9> KEYS_FUNC keydef!
    <F10> KEYS_FUNC keydef!
    <F11> KEYS_FUNC keydef!
    \ <F12> KEYS_FUNC keydef!  \ reserved!

    <q> KEYS_QWERTY keydef!
    <w> KEYS_QWERTY keydef!
    <e> KEYS_QWERTY keydef!
    <r> KEYS_QWERTY keydef!
    <t> KEYS_QWERTY keydef!
    <y> KEYS_QWERTY keydef!
    <u> KEYS_QWERTY keydef!
    <i> KEYS_QWERTY keydef!
    <o> KEYS_QWERTY keydef!
    <p> KEYS_QWERTY keydef!
    <a> KEYS_QWERTY keydef!
    <s> KEYS_QWERTY keydef!
    <d> KEYS_QWERTY keydef!
    <f> KEYS_QWERTY keydef!
    <g> KEYS_QWERTY keydef!
    <h> KEYS_QWERTY keydef!
    <j> KEYS_QWERTY keydef!
    <k> KEYS_QWERTY keydef!
    <l> KEYS_QWERTY keydef!
    <z> KEYS_QWERTY keydef!
    <x> KEYS_QWERTY keydef!
    <c> KEYS_QWERTY keydef!
    <v> KEYS_QWERTY keydef!
    <b> KEYS_QWERTY keydef!
    <n> KEYS_QWERTY keydef!
    <m> KEYS_QWERTY keydef!

: ?filter
    role @ -exit  \ no role = no filter
    dup keydef@  my-keygroup @ and ?exit
    drop 0 r> drop ; 

: klast      ?filter  kblast keydown ;
: kstate     ?filter  kbstate keydown ;
: kdelta     >r  r@ kstate #1 and  r> klast #1 and  - ;
: pressed    kdelta #1 = ;
: released   kdelta #-1 = ;
