


library(magick)


list.files("/usr/share/fonts/truetype/ubuntu/")

font_path <- "/usr/share/fonts/"

# --- Caminho recomendado para as fontes Ubuntu ---
# Opção A: Aponta para o diretório geral de TrueType (onde muitas fontes estão)
# font_path <- "/usr/share/fonts/truetype"

# Ou Opção B (mais abrangente): Inclui TrueType e OpenType
# font_path <- "/usr/share/fonts/truetype/:/usr/share/fonts/opentype/"

# Se você sabe que existe um subdiretório 'ubuntu' dentro de 'truetype':
 # font_path <- "/usr/share/fonts/truetype/ubuntu"

# 2. Defina a variável de ambiente MAGICK_FONT_PATH
Sys.setenv(MAGICK_FONT_PATH = font_path)

# 3. Verifique se o caminho foi definido
print(paste("MAGICK_FONT_PATH definido para:", Sys.getenv("MAGICK_FONT_PATH")))

# 4. Verifique se as fontes são detectadas agora
# ubuntu_fonts <- image_fonts()
# # Tente filtrar por "Ubuntu" (o nome real pode ser ligeiramente diferente, ex: "Ubuntu Bold")
# found_ubuntu <- ubuntu_fonts[grepl("ubuntu", ubuntu_fonts$name, ignore.case = TRUE), ]
# #
# if (nrow(found_ubuntu) > 0) {
#   print("Fontes 'Ubuntu' encontradas:")
#   print(found_ubuntu)


all_magick_fonts <- magick_fonts()

class(all_magick_fonts)
all_magick_fonts |> dplyr::select(family) |> dplyr::arrange()

# Ler imagem diretamente da web
bdc <- image_read("https://data.inpe.br/bdc/web/wp-content/uploads/slider6/logo-brazil-data-cube-inpe.png") |>
  image_scale("250x")

bdc_bg <- image_background(bdc, color = "black", flatten = TRUE)
# print(bdc_bg)
# rm(bdc)


fundo <- image_blank(width = 1200, height = 300, color = "#042444")

# Ler e redimensionar imagem
# logo <- image_read("https://www.r-project.org/logo/Rlogo.png") |>
#   image_scale("50x")

# Compor logo sobre fundo
banner <- image_composite(fundo, bdc, offset = "+25+25")

# Visualizar
print(banner)

### ----

# Adicionar texto
banner_texto <- image_annotate(
  banner,
  text = "brazil-data-cube/",     # Texto
  color = "#b5bfc8",               # Cor do texto
  size = 28,                     # Tamanho da fonte
  # font =  "Pagul",
  font =  "Ubuntu Mono",   # Fonte (deve estar instalada no sistema)
  location = "+70+120",         # Posição (x,y) a partir do canto superior esquerdo
  gravity = "NorthWest",         # Referência da posição (nesse caso, canto superior esquerdo)
  weight = 400                   # Peso da fonte (opcional)
)


#
# # Visualizar
print(banner_texto)

banner_texto <- banner_texto %>%
  image_annotate(
    text = "rstac",
    font = "mono",
    weight = 700,
    # style = "italic",
    size = 40,
    color = "white",
    gravity = "southwest",
    location = "+70+100"
  ) %>%
  image_annotate(
    text = "R Client Library for Spatio Temporal Asset Catalog",
    font = "mono",
    weight = 200,
    # style = "italic",
    size = 16,
    color = "grey80",
    gravity = "southwest",
    location = "+70+60"
  )


imagem2 = magick::image_read("https://data.inpe.br/bdc/web/wp-content/uploads/2020/12/rStac_logo.png") |>
  image_scale("120x")

print(imagem2)


# Adicionar a segunda imagem ao banner
banner_com_imagens <- image_composite(
  image = banner_texto, # Usa o banner com a primeira imagem já adicionada
  composite_image = imagem2,
  gravity = "northeast", # Posiciona a imagem no canto inferior direito
  offset = "+50+15"      # Desloca 20 pixels para a esquerda e 20 para cima
)

# plot(banner_com_imagens)
print(banner_com_imagens)

gdalcub = magick::image_read("https://gdalcubes.github.io/source/gdalcubes_logo_small.png") |>
  image_scale("120x")


print(gdalcub)


banner  <- image_composite(
  image = banner_com_imagens, # Usa o banner com a primeira imagem já adicionada
  composite_image = gdalcub,
  gravity = "southeast", # Posiciona a imagem no canto inferior direito
  offset = "+50+15"      # Desloca 20 pixels para a esquerda e 20 para cima
)

print(banner)

image_write(banner, path = "rstac-magick-image.png", format = "png")
