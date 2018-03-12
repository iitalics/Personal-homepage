shiny = (function () {
  "use strict";

  let container = null;
  function create_line_elem(width, color) {
    if (container == null)
      container = document.getElementById("dance");

    let ln = document.createElement("span");
    ln.classList.add("line");
    ln.style.width = width;
    ln.style.height = 1;
    ln.style.backgroundColor = color;
    container.appendChild(ln);
    return ln;
  }

  function create_wave_fn() {
    let f0 = Math.random() * 2;
    let f1 = 1 + Math.random() * 4;
    let f2 = 3 + Math.random() * 10;
    let a0 = 10 + Math.random() * 5;
    let a1 = 20 + Math.random() * 30;
    let a2 = Math.random() * 10;
    let o0 = Math.random() * 2;
    let o1 = Math.random() * 2;
    return function (t) {
      return a0 * Math.sin(f0 * t + o0)
        + a1 * Math.sin(f1 * t + o1)
        + a2 * Math.sin(f2 * t);
    };
  }

  function create_color() {
    let r0 = 40;
    let g0 = 110;
    let b0 = 200;
    let r1 = 40;
    let g1 = 255;
    let b1 = 100;

    let r = ~~(r0 + (r1 - r0) * Math.random());
    let g = ~~(g0 + (g1 - g0) * Math.random());
    let b = ~~(b0 + (b1 - b0) * Math.random());
    return "rgb(" + r + "," + g + "," + b + ")";
  }

  let lines = [];
  let widths = [];
  let x_wave_fns = [];
  let y_wave_fns = [];
  let spins = [];

  const LINES = 12;

  function create_line() {
    let w = 20 + Math.random() * 15;
    let spin = 100 + Math.random() * 200;
    let spin_off = Math.random() * 360;
    let color = create_color();
    lines.push(create_line_elem(w, color));
    widths.push(w);
    x_wave_fns.push(create_wave_fn());
    y_wave_fns.push(create_wave_fn());
    spins.push([spin_off, spin]);
  }

  function update_one(i, x, y, rot) {
    x -= widths[i];
    lines[i].style.transform = "translate(" + ~~x + "px, " + ~~y + "px) rotate(" + (rot % 360) + "deg)";
  }

  function update() {
    let t = new Date / 1000;
    for (let i = 0; i < lines.length; i++) {
      let x = x_wave_fns[i](t);
      let y = 60 + y_wave_fns[i](t);
      let rot = spins[i][0] + spins[i][1] * t;
      update_one(i, x, y, rot);
    }
  }

  let update_ival = setInterval(update, 20);

  let create_ival = setInterval(_ => {
    if (lines.length < LINES) {
      create_line();
      update();
    }
    else
      clearInterval(create_ival);
  }, 400);

    return { lines, x_wave_fns, y_wave_fns, widths, spins };
})();
