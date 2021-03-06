cask 'lilypond-dev' do
  version '2.19.83-1'
  sha256 '15e763e908d1371fb3f8151f73ece23bdd8ea7bc757f427f067d8418659c15c3'

  url "http://lilypond.org/downloads/binaries/darwin-x86/lilypond-#{version}.darwin-x86.tar.bz2"
  appcast 'http://lilypond.org/development.html'
  name 'LilyPond'
  homepage 'http://lilypond.org/'

  app 'LilyPond.app'

  binaries = [
               'abc2ly',
               'convert-ly',
               'lilypond',
               'lilypond-book',
               'musicxml2ly',
             ]

  binaries.each do |shimscript|
    binary "#{staged_path}/#{shimscript}.wrapper.sh", target: shimscript
  end

  preflight do
    binaries.each do |shimscript|
      # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
      IO.write "#{staged_path}/#{shimscript}.wrapper.sh", <<~EOS
        #!/bin/sh
        exec '#{appdir}/LilyPond.app/Contents/Resources/bin/#{shimscript}' "$@"
      EOS
    end
  end

  zap trash: [
               '~/Library/Preferences/org.lilypond.lilypond.plist',
               '~/Library/Preferences/org.lilypond.lilypond.LSSharedFileList.plist',
             ]
end
