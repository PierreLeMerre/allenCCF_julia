function acronym2mesh(st,acronym,path)
    df = DataFrame(st[2:end,:],:auto)
    rename!(df,Symbol.(st[1,:]))
    id = acronym2id(acronym,df)[1]
    c = acronym2hexcolor(acronym,df)[1]
    brain_region = load(path*string(id)*".obj")
    return brain_region, c
end