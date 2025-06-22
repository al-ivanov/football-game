return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 100,
  tileheight = 100,
  nextobjectid = 6,
  properties = {},
  tilesets = {
    {
      name = "mytiles",
      firstgid = 1,
      tilewidth = 100,
      tileheight = 100,
      spacing = 0,
      margin = 0,
      image = "../Documents/game_dev/maps/mytiles.png",
      imagewidth = 600,
      imageheight = 600,
      transparentcolor = "#ff00ff",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 100,
        height = 100
      },
      properties = {},
      terrains = {},
      tilecount = 36,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "bgLayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 11, 10, 12, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 14, 10, 12, 11, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 11, 1, 10, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 15, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 19, 19, 1, 19, 19, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 19, 19, 16, 19, 19, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "blkLayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        28, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 31,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25,
        29, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 30
      }
    },
    {
      type = "objectgroup",
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 3,
          name = "exit",
          type = "",
          shape = "rectangle",
          x = 1100,
          y = 1000,
          width = 100,
          height = 100,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 500,
          y = 1400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1500,
          y = 1500,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
