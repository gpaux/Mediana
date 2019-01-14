font_family = "Ekibastuz"
sysfonts::font_add(family = font_family, regular = "ekibastuz_regular.otf")

hexSticker::sticker("inst/figures/logo_MEDIANAINC.png",
                  package="Mediana",
                  s_x=1,
                  s_y=1,
                  s_width=0.5,
                  s_height=0.5,
                  p_color = "white",
                  p_family = font_family,
                  p_size = 34,
                  p_x = 1,
                  p_y = 1.6,
                  h_fill = "#EE3223",
                  h_color = "#AE3927",
                  url = "http://gpaux.github.io/Mediana",
                  u_size = 6,
                  u_color = "white",
                  asp = 1,
                  filename = "inst/figures/hexMediana.png",
                  dpi = 600
)
