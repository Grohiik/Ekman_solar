using Plots


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
# Detta ser till att vi får reella talet 0 när solen inte lyser på våran platts på jorden.

I_p(n, t) = I(n, t) * (cos(teta_p - teta_s(n, t)) * cos(alfa_p - alfa_s(n, t)) + sin(alfa_s(n, t)) * sin(alfa_p) * (1 - cos(teta_p - teta_s(n, t))))

weather_loss = 1-(1821/(365*12))

P(x) = (*(((abs(I_p(floor(x/24), x))+I_p(floor(x/24), x))/2),weather_loss , eff, area))


s_date = 152
e_date = 181
step = 0.1


x = 24*s_date:step:24*(e_date)+24
x = filter(x->x%12!=0,x)
# samma som i sun, men nu behövs det faktiskt eftersom vi kollar på ett större spann och behöver mer presicion. 
# vi kan inte häller använda plot funktionen eftersom vi integrerar nu.

kwh = 0

for i in x
    global kwh += i*P(i)
end


print(kwh)
