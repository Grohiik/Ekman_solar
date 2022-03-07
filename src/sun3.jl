using Plots

s_date = 0
e_date = 31

function kwt_alfa(degalfa_p)
    eff = 0.15
    area = 30

    teta_p = deg2rad(170)
    alfa_p = deg2rad(degalfa_p)

    lat = deg2rad(59.3)

    delta_s(n) = deg2rad(-23.44) * cos((2pi / 365) * n)

    omega(t) = deg2rad((15 * t) - 180)

    alfa_s(n, t) = asin(sin(lat) * sin(delta_s(n)) + cos(lat) * cos(delta_s(n)) * cos(omega(t)))

    teta_s(n, t) = pi + (omega(t) / abs(omega(t))) * acos((sin(lat) * sin(alfa_s(n, t)) - sin(delta_s(n))) / (cos(lat) * cos(alfa_s(n, t))))

    I_0 = 1360
    I(n, t) = 1.1 * I_0 * 0.7^((1 / (abs(sin(alfa_s(n, t))) + sin(alfa_s(n, t))) / 2)^0.678)  # underlig abs medelvärde för att få 0 om negativt värde

    I_p(n, t) = I(n, t) * (cos(teta_p - teta_s(n, t)) * cos(alfa_p - alfa_s(n, t)) + sin(alfa_s(n, t)) * sin(alfa_p) * (1 - cos(teta_p - teta_s(n, t))))


    weather_loss = 1 - (1821 / (365 * 12))

    P(x) = (*(((abs(I_p(floor(x / 24), x)) + I_p(floor(x / 24), x)) / 2), weather_loss, eff, area))


    step = 0.1


    x = 24*s_date:step:24*(e_date)+24
    x = filter(x -> x % 12 != 0, x)

    wh = 0

    for i in x
        wh += step * P(i)
    end

    return wh / 1000
end

function maxer()
    values = Float64[]
    for i in 0:1:90
        push!(values, kwt_alfa(i))
    end
    return findmax(values)[2] - 1
end

maxvalues = Int[]
# january
push!(maxvalues, maxer())

#february
s_date = 32
e_date = 59
push!(maxvalues, maxer())

#march
s_date = 60
e_date = 90
push!(maxvalues, maxer())

#april
s_date = 91
e_date = 120
push!(maxvalues, maxer())

#may
s_date = 121
e_date = 151
push!(maxvalues, maxer())

#june
s_date = 152
e_date = 181
push!(maxvalues, maxer())

#july
s_date = 182
e_date = 212
push!(maxvalues, maxer())

#august
s_date = 213
e_date = 243
push!(maxvalues, maxer())

#september
s_date = 244
e_date = 273
push!(maxvalues, maxer())

#october
s_date = 274
e_date = 304
push!(maxvalues, maxer())

#november
s_date = 305
e_date = 334
push!(maxvalues, maxer())

#december
s_date = 335
e_date = 365
push!(maxvalues, maxer())

plot(1:12, maxvalues, label = "", xticks = 1:12)

xlabel!("Optimal elevationsvinkel[grader]")
ylabel!("Månad")

savefig("blub.svg")

