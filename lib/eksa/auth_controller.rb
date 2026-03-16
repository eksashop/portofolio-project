module Eksa
  class AuthController < Eksa::Controller
    def login
      return redirect_to "/cms" if current_user
      render_internal 'auth/login'
    end

    def register
      return redirect_to "/cms" if current_user
      @admin_exists = Eksa::User.all.any?
      render_internal 'auth/register'
    end

    def process_login
      username = params['username']
      password = params['password']
      
      user = Eksa::User.authenticate(username, password)
      if user
        session['user_id'] = user[:id]
        redirect_to "/cms", notice: "Selamat datang kembali, #{username}!"
      else
        redirect_to "/auth/login", notice: "Username atau password salah."
      end
    end

    def process_register
      if Eksa::User.all.any?
        return redirect_to "/auth/login", notice: "Registrasi ditutup. Hanya satu admin yang diizinkan."
      end

      username = params['username']
      password = params['password']
      
      if username && !username.empty? && password && password.length >= 6
        Eksa::User.create_user(username, password)
        user = Eksa::User.authenticate(username, password)
        session['user_id'] = user[:id]
        redirect_to "/cms", notice: "Akun berhasil dibuat. Selamat datang!"
      else
        redirect_to "/auth/register", notice: "Data tidak valid. Password minimal 6 karakter."
      end
    end

    def logout
      session.delete('user_id')
      redirect_to "/", notice: "Anda telah berhasil logout."
    end
  end
end
