 NUM2CHAR   Converts numeric Array's to CharacterArrays

  C = NUM2CHAR( Array , Replace );

  default: Replace == ' ';  % SpaceCharacter

  The values of Array will transformed into Interval [ 0 .. 255 ]
  Bad Characters will replaced.

  Good Characters are:  9, 10, 13, [ 28 .. 126 ], [ 160 .. 255 ]