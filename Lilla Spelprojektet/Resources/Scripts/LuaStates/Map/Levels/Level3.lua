return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.5",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 28,
  height = 39,
  tilewidth = 48,
  tileheight = 48,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "diffuse",
      firstgid = 1,
      filename = "../../../../../diffuse.tsx",
      tilewidth = 48,
      tileheight = 48,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 11,
      tiles = {
        {
          id = 0,
          properties = {
            ["ignore"] = false
          },
          image = "Resources/Sprites/brick_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 1,
          properties = {
            ["ignore"] = false
          },
          image = "Resources/Sprites/pyramid_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 2,
          properties = {
            ["ignore"] = false
          },
          image = "Resources/Sprites/iron_block_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 3,
          properties = {
            ["ignore"] = false
          },
          image = "Resources/Sprites/brickSolidMix_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 4,
          properties = {
            ["ignore"] = false
          },
          image = "Resources/Sprites/solidScrew_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 5,
          properties = {
            ["ignore"] = true
          },
          image = "Resources/Sprites/ironPillar_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 6,
          properties = {
            ["ignore"] = true
          },
          image = "Resources/Sprites/lockerBottom_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 7,
          properties = {
            ["ignore"] = true
          },
          image = "Resources/Sprites/lockerTop_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 8,
          properties = {
            ["ignore"] = true
          },
          image = "Resources/Sprites/lampCoord_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 9,
          properties = {
            ["ignore"] = true
          },
          image = "Resources/Sprites/durkplat_diffuse.png",
          width = 48,
          height = 48
        },
        {
          id = 10,
          properties = {
            ["ignore"] = true
          },
          image = "Resources/Sprites/chain_diffuse.png",
          width = 48,
          height = 48
        }
      }
    },
    {
      name = "normal",
      firstgid = 12,
      filename = "../../../../../normal.tsx",
      tilewidth = 48,
      tileheight = 48,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 11,
      tiles = {
        {
          id = 0,
          image = "Resources/Sprites/brick_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 1,
          image = "Resources/Sprites/pyramid_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 2,
          image = "Resources/Sprites/iron_block_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 3,
          image = "Resources/Sprites/brickSolidMix_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 4,
          image = "Resources/Sprites/solidScrew_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 5,
          image = "Resources/Sprites/ironPillar_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 6,
          image = "Resources/Sprites/lockerBottom_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 7,
          image = "Resources/Sprites/lockerTop_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 8,
          image = "Resources/Sprites/lampCoord_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 9,
          image = "Resources/Sprites/durkplat_normal.png",
          width = 48,
          height = 48
        },
        {
          id = 10,
          image = "Resources/Sprites/chain_normal.png",
          width = 48,
          height = 48
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 28,
      height = 39,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 6, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 6, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 6, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 5, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 0, 0, 0, 0, 4, 4, 4, 1, 1, 5, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    }
  }
}
