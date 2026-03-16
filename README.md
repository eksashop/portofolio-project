# ✨ Eksa Framework

[![Ruby Version](https://img.shields.io/badge/ruby-3.0+-red.svg)](https://www.ruby-lang.org/)
[![Rack Version](https://img.shields.io/badge/rack-3.0+-blue.svg)](https://rack.github.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Framework Role](https://img.shields.io/badge/UI-Glassmorphism-indigo.svg)](#)

**Eksa Framework** adalah *micro-framework* MVC (Model-View-Controller) modern yang dibangun di atas Ruby dan Rack. Didesain untuk pengembang yang menginginkan kecepatan, kode yang bersih, dan tampilan antarmuka **Glassmorphism** yang elegan secara *out-of-the-box*.

---

## 🚀 Fitur Unggulan

* 💎 **Modern Glassmorphism UI**: Tampilan transparan yang indah dengan Tailwind CSS & Lucide Icons.
* ⚡ **Rack 3 & Middleware Support**: Mendukung standar terbaru dan pembuatan pipeline middleware kustom.
* 🛠️ **Powerful CLI**: Inisialisasi project (`eksa init`), jalankan server (`eksa run`), generate komponen, dan **auto-routing** otomatis.
* 💾 **MongoDB with Mongoid**: Integrasi database NoSQL modern menggunakan Mongoid untuk performa dan fleksibilitas tinggi.
* ☁️ **Cloudinary Image Hosting**: Management aset gambar secara otomatis di Cloud untuk post blog dan CMS.
* 🧪 **Built-in Testing**: Lingkungan pengujian otomatis siap pakai menggunakan RSpec dan `rack-test`.
* 🛡️ **Built-in Authentication**: Sistem keamanan BCrypt dengan proteksi sesi Rack untuk registrasi log-in area Admin.
* 📝 **Interactive CMS Dashboard**: Panel admin integratif untuk mengedit isi blog Markdown & transisi visibilitas via UI.
* 🎨 **Asset Helpers**: Library bawaan untuk pengelolaan CSS dan JS yang lebih rapi.
* 🔍 **Dynamic SEO Engine**: Penanganan otomatis file `robots.txt` dan `sitemap.xml`.
* 💎 **JSON-LD Support**: Dukungan data terstruktur (Structured Data) otomatis untuk SEO yang lebih optimal.
* 👻 **Aesthetic Error Pages**: Halaman 404 dengan desain Glassmorphism yang elegan secara native.

---

## 🛠️ Instalasi Cepat

### 1. Install via Gem
```bash
gem install eksa-framework
```

### 2. Inisialisasi Project Baru
```bash
mkdir my-app && cd my-app
eksa init
```

### 3. Konfigurasi Environment
Buat file `.env` dan tambahkan detail Cloudinary serta MongoDB Anda:
```env
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
MONGODB_URI=mongodb://localhost:27017/eksa_app
```

### 4. Jalankan Server
```bash
bundle install
eksa run
```

---

## 💻 Panduan Pengembangan

### 1. Konfigurasi Aplikasi (`config.ru`)
Eksa menggunakan `Mongoid` dan `Cloudinary` yang dikonfigurasi secara otomatis jika variabel env tersedia:

```ruby
require 'dotenv/load'
require 'mongoid'
require 'cloudinary'

Mongoid.load!("config/mongoid.yml", :development)

app = Eksa::Application.new do |config|
  config.use Rack::Static, urls: ["/css", "/img", "/uploads"], root: "public"
  config.use Rack::ShowExceptions
end
```

### 2. CLI Generator
Hemat waktu dengan menggunakan generator bawaan:

```bash
# Membuat controller dan view template
eksa g controller Blog

# Membuat model Mongoid (Otomatis menggunakan Mongoid::Document)
eksa g model Post

# Membuat postingan blog baru dengan meta tambahan
eksa g post "Judul Artikel" --category "Kategori" --author "Nama Penulis" --image "url-gambar.jpg"
```

### 3. CMS Dashboard & Authentication
Eksa hadir dengan sistem manajemen konten internal bergaya Glassmorphism.

*   **Aktivasi**: Pastikan `MONGODB_URI` sudah dikonfigurasi.
*   **Registrasi**: Akses `http://localhost:9292/auth/register` (Hanya akun pertama yang bisa mendaftar sebagai Administrator).
*   **Akses Dasbor**: Masuk ke rute `/cms` untuk melihat postingan, mengedit project, dan mengelola portofolio.

### 4. Database & Model (Mongoid)
Definisikan schema tabel Anda menggunakan sintaks Mongoid:

```ruby
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :image_url, type: String
end
```

### 5. Asset Helpers
Gunakan helper di dalam view untuk menyisipkan asset:

```erb
<%= stylesheet_tag "style" %>
<%= javascript_tag "app" %>
```

### 6. Menjalankan Test
Pastikan aplikasi Anda berjalan dengan benar menggunakan RSpec:

```bash
bundle exec rspec
```

---

## 🤝 Kontribusi
Kami menerima kontribusi dalam bentuk apapun! Silakan buat **Pull Request** atau laporkan **Issue** jika Anda menemukan bug atau memiliki saran fitur.

## 📜 Lisensi
Proyek ini dilisensikan di bawah **MIT License**. Lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.