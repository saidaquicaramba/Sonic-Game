extends Node

# Camadas de física e renderização
const LAYER_PLAYER = 1
const LAYER_PLATFORM = 2
const LAYER_ENEMY = 3
const LAYER_HITBOX = 4
const LAYER_HURTBOX = 5
const LAYER_COLLECTIBLE = 6

# Máscaras de colisão
const MASK_PLAYER = 1 << (LAYER_PLATFORM - 1) | 1 << (LAYER_ENEMY - 1)
const MASK_PLATFORM = 1 << (LAYER_PLAYER - 1)
const MASK_ENEMY = 1 << (LAYER_PLAYER - 1)
const MASK_HITBOX = 1 << (LAYER_ENEMY - 1) | 1 << (LAYER_HURTBOX - 1)
const MASK_HURTBOX = 1 << (LAYER_HITBOX - 1)
