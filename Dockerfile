# Establecer la imagen base
FROM ruby:3.2.2

# Instalar dependencias
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libsqlite3-dev libcurl4-openssl-dev

# Instalar libvips
RUN apt-get install -y libvips42

# Establecer la carpeta de trabajo en el contenedor
WORKDIR /Zapateria

# Copiar el Gemfile y Gemfile.lock al contenedor
COPY Gemfile /Zapateria/Gemfile
COPY Gemfile.lock /Zapateria/Gemfile.lock

# Instalar las gemas
RUN bundle install

# Copiar el código de la aplicación al contenedor
COPY . /Zapateria

# Exponer el puerto 3000
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["rails", "server", "-b", "0.0.0.0"]
