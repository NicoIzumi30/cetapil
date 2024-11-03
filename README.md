
# Cetapil Project

Dokumentasi ini dibuat bertujuan untuk memudahkan developer dalam melakukan installasi project cetapil yang berbasis laravel 11.




![Logo](https://i.postimg.cc/FFqn6Bv0/wp11840910-frieren-wallpapers-1.jpg)


## Persyaratan

- PHP versi 8.2 atau lebih tinggi
- Composer versi terbaru
- Database (MySQL)




## Installation

Clone the project

```bash
  git clone https://github.com/NicoIzumi30/cetapil.git
```
Go to the project directory
```bash
  cd cetapil
```
Install dependencies
```bash
  composer install
```
Create configuration file .env
```bash
  cp .env.example .env
```
Configuration Database
```bash
  DB_CONNECTION=mysql
  DB_HOST=127.0.0.1
  DB_PORT=3306
  DB_DATABASE=nama_database_anda
  DB_USERNAME=username_anda
  DB_PASSWORD=password_anda
```
Generate Application Key
```bash
  php artisan key:generate
```
Migrate and Seed Database
```bash
  php artisan migrate --seed
```
## Run Project
```bash
  php artisan serve
```