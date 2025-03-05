for f in glob($HOME . '/.zv/**/*.vim', 0, 1)
    execute 'source ' . f
endfor
