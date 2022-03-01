using Plots

#dag = 350
dag = 160

eff = 0.15
area = 1

teta_p = deg2rad(170)
alfa_p = deg2rad(35)

lat = deg2rad(59)

delta_s(n) = deg2rad(-23.44) * cos((2pi / 365) * n)

omega(t) = deg2rad((15 * t) - 180)

alfa_s(n, t) = asin(sin(lat) * sin(delta_s(n)) + cos(lat) * cos(delta_s(n)) * cos(omega(t)))

teta_s(n, t) = pi + (omega(t) / abs(omega(t))) * acos((sin(lat) * sin(alfa_s(n, t)) - sin(delta_s(n))) / (cos(lat) * cos(alfa_s(n, t))))

I_0 = 1360
I(n, t) = 1.1 * I_0 * 0.7^((1 / sin(alfa_s(n, t)))^0.678)

I_p(n, t) = I(n, t) * (cos(teta_p - teta_s(n, t)) * cos(alfa_p - alfa_s(n, t)) + sin(alfa_s(n, t)) * sin(alfa_p) * (1 - cos(teta_p - teta_s(n, t))))


#P(x) = (I(dag, x))

test(x) = (alfa_s(dag, x))

#plot(P, 0, 24, title = "here comes the sun")
plot(test, 0, 24)

xlabel!("t")
ylabel!("Watt")

savefig("sun.svg")
