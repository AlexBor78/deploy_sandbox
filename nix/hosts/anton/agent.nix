# /nix/host/anton/agent.nix

{ config, lib, pkgs, ... } : {
  users.users.agent = {
    isNormalUser = true;
    extraGroups = [ ];
    shell = pkgs.bash;
    packages = with pkgs; [
    # usless placeholders
    	powertop
    	dmidecode
    	p7zip

      # LLM + runtime
      ollama
      nodejs_22

        # Python для агента
        (python3.withPackages (ps: with ps; [
          requests
          beautifulsoup4
          pandas
          matplotlib
          pillow
          flask
          pyyaml
        ]))

        # Поиск и файлы
        ripgrep
        fd
        file

        # Текст и данные
        yq
        pandoc
        csvkit

        # Сеть
        httpie

        # Архивы
        unzip
        zip

        # Медиа
        imagemagick
        ffmpeg

        # Разное
        sqlite
        bc
    ];
  }
}
