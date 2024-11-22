function acronym2id(name,df)
    #filter the dataframe for PFC regions
    n = name
    row = filter(r ->n==r.acronym, df)
    return row.id
end