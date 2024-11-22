function acronym2hexcolor(name,df)
    #filter the dataframe for PFC regions
    n = name
    row = filter(r ->n==r.acronym, df)
    return row.color_hex_triplet
end