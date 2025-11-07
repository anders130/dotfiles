tag @s add yummy_jump
say Yummy!
playsound minecraft:entity.illusioner.ambient player @s ~ ~ ~ 1 1
effect give @s minecraft:levitation 100 35 true
schedule function yummy_jump:end_jump 2t replace
