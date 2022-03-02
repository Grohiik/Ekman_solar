using Plots

dag = 160
#dag = 160

eff = 0.15
area = 30

teta_p = deg2rad(170)
alfa_p = deg2rad(35)

lat = deg2rad(59.3)

delta_s(n) = deg2rad(-23.44) * cos((2pi / 365) * n)

omega(t) = deg2rad((15 * t) - 180)

alfa_s(n, t) = asin(sin(lat) * sin(delta_s(n)) + cos(lat) * cos(delta_s(n)) * cos(omega(t)))

teta_s(n, t) = pi + (omega(t) / abs(omega(t))) * acos((sin(lat) * sin(alfa_s(n, t)) - sin(delta_s(n))) / (cos(lat) * cos(alfa_s(n, t))))

I_0 = 1360
I(n, t) = 1.1 * I_0 * 0.7^((1 / (abs(sin(alfa_s(n, t)))+sin(alfa_s(n, t)))/2)^0.678)  # underlig abs medelvärde för att få 0 om negativt värde

I_p(n, t) = I(n, t) * (cos(teta_p - teta_s(n, t)) * cos(alfa_p - alfa_s(n, t)) + sin(alfa_s(n, t)) * sin(alfa_p) * (1 - cos(teta_p - teta_s(n, t))))


P(n, t) = (*(((abs(I_p(n, t))+I_p(n, t))/2), eff, area))


s_date = 1
e_date = 31
s_time = 0
e_time = 24
step = 0.1

kwh = 0

for i in s_date:e_date
    for j in s_time:step:e_time
        #NEED good way to get number of light hours in a day or month. could count it but seems bumb
        global kwh += P(i, j)
    end
end

kwh /= (e_date-s_date)*((e_time-s_date)/step)

print(kwh)

P(x) = (*(((abs(I_p(floor(x/24), x))+I_p(floor(x/24), x))/2), eff, area))

x = 24*dag+5:0.01:24*(dag+30)+20

x = filter(x->x%12!=0,x)

plot(x, P.(x), title = "Stockholm", label = "Juni")

#P(x) = (*(((abs(I_p(dag, x))+I_p(dag, x))/2), eff, area))
#plot!(P, 5, 18, label = "Januari")
#plot!(test, 0, 24, label = "I/1000")

xlabel!("tid[h]")
ylabel!("P[W]")

#savefig("effekt_utan_area_stockholm.svg")