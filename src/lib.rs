#[macro_use]
extern crate ruru;
extern crate la;

use la::{Matrix, SVD};

#[no_mangle]
pub extern fn init_rusty_svd() {
  let a = m!(1.0, 2.0; 3.0, 4.0; 5.0, 6.0);
  let b = m!(7.0, 8.0, 9.0; 10.0, 11.0, 12.0);
  let c = (a * b).t();
  println!("{:?}", c);

  let svd = SVD::new(&c);
  println!("{:?}", svd.get_s());
}
