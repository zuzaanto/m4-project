function v1 = vanishing_point(xo1, xf1, xo2, xf2)

x1 = cross(xo1, xf1);
x2 = cross(xo2, xf2);

v1 = cross(x1, x2);

end