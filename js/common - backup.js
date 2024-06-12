gsap.registerPlugin(MotionPathPlugin);
gsap.registerPlugin(ScrollToPlugin);
gsap.registerPlugin(ScrollTrigger, ScrollSmoother);

ScrollSmoother.create
({
      wrapper: '.wrapper',
      content: '.content'
})


function getMinNumber(a, b)
{
  return a < b ? a : b;
}

function getMaxNumber(a, b)
{
  return a > b ? a : b;
}

function get_random_int(min, max)
{
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function mix_list(list)
{
  for (let i = list.length - 1; i > 0; i--)
  {
    const j = Math.floor(Math.random() * (i + 1));
    [list[i], list[j]] = [list[j], list[i]];
  }
  return list;
}


let base_color_0 = 'rgba(0, 255, 255, 0)', base_color_0_5 = 'rgba(0, 255, 255, .5)', base_color_1 = 'rgba(0, 255, 255, 1)';
let scroll_flag = {fl: false};
let logo_animation_flag = {fl: false};

document.addEventListener('DOMContentLoaded', function()
{
  const duration_fix = .2;
  
  let tl_start = gsap.timeline();
  tl_start.to({}, {duration: duration_fix,
    onComplete: function()
    {
      let window_width = window.innerWidth, window_height = window.innerHeight;
      let window_aspect_ratio = window_width / window_height;
      
      let tl_scroll = gsap.timeline(), tl_blur = gsap.timeline();
    
      let main = document.getElementsByClassName('main');
      main = main[0];
      const childrens_main = main.children;
      const childrens_main_cnt = childrens_main.length;
      let current_ind_childrens_main = 0;
    
    
      let filter_need = document.getElementsByClassName('filter-need');
      filter_need = filter_need[0];
      
      let touch_x_down = null;
      let touch_y_down = null;
    
      const duration_scroll = .65;
      
      function handle_touch_start(event)
      {
        touch_x_down = event.touches[0].clientX;
        touch_y_down = event.touches[0].clientY;
      }
      
      function handle_touch_move(event)
      {
        
        let scrolled_height = main.scrollTop;
        let main_height = main.getBoundingClientRect().height;
        
        if (!touch_x_down || !touch_y_down)
        {
          return;
        }
      
        let touch_x_up = event.touches[0].clientX;
        let touch_y_up = event.touches[0].clientY;
        let touch_x_diff = touch_x_down - touch_x_up;
        let touch_y_diff = touch_y_down - touch_y_up;
      
        if (Math.abs(touch_x_diff) > Math.abs(touch_y_diff))
        {
          if (touch_x_diff > 0)
          {
            // console.log('Свайп влево');
          }
          else
          {
            // console.log('Свайп вправо');
          }
        }
        else
        {
          if (scroll_flag.fl == false)
          {
            scroll_flag.fl = true; //current_ind_childrens_main > 0 && 
            if (current_ind_childrens_main + 1 < childrens_main_cnt && touch_y_diff > 0)
            {
              tl_scroll.to(main, {duration: duration_scroll, ease: 'power2.inOut', scrollTo: childrens_main[current_ind_childrens_main + 1].offsetTop,
                onComplete: function()
                {
                  current_ind_childrens_main++;
                  scroll_flag.fl = false;
                }
              });
    
              if (current_ind_childrens_main == 0)
              {
                tl_blur.clear();
                tl_blur = gsap.timeline();
                tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', filter: 'blur(0px)'});
              }
    
              // console.log('Свайп вниз');
            }
            else if (current_ind_childrens_main > 0 && touch_y_diff < 0)
            {
              tl_scroll.to(main, {duration: duration_scroll, ease: 'power2.inOut', scrollTo: childrens_main[current_ind_childrens_main - 1].offsetTop,
                onComplete: function()
                {
                  current_ind_childrens_main--;
                  scroll_flag.fl = false;
                }
              });
    
              if (current_ind_childrens_main == 1)
              {
                tl_blur.clear();
                tl_blur = gsap.timeline();
                tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', filter: 'blur(7px)'});
              }
    
              // console.log('Свайп вверх');
            }
            else
            {
              scroll_flag.fl = false;
            }
          }
        }
        touch_x_down = null;
        touch_y_down = null;
      }
    
      function handle_scroll_move(event)
      {
        event.preventDefault();
        if (scroll_flag.fl == false)
        {
          scroll_flag.fl = true;
          if (current_ind_childrens_main + 1 < childrens_main_cnt && event.deltaY > 0)
          {
            tl_scroll.to(main, {duration: duration_scroll, ease: 'power2.inOut', scrollTo: childrens_main[current_ind_childrens_main + 1].offsetTop,
                onComplete: function()
                {
                  current_ind_childrens_main++;
                  scroll_flag.fl = false;
                }
            });
            if (current_ind_childrens_main == 0)
            {
              tl_blur.clear();
              tl_blur = gsap.timeline();
              tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', filter: 'blur(0px)'});
            }
            // console.log("down");
          }
          else if(current_ind_childrens_main > 0 && event.deltaY < 0)
          {
            tl_scroll.to(main, {duration: duration_scroll, ease: 'power2.inOut', scrollTo: childrens_main[current_ind_childrens_main - 1].offsetTop,
                onComplete: function()
                {
                  current_ind_childrens_main--;
                  scroll_flag.fl = false;
                }
            });
            if (current_ind_childrens_main == 1)
            {
              tl_blur.clear();
              tl_blur = gsap.timeline();
              tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', filter: 'blur(7px)'});
            }
            // console.log("up");
          }
          else
          {
            scroll_flag.fl = false;
          }
        }
      }
    
      window.addEventListener('wheel', handle_scroll_move, { passive: false });
      document.addEventListener('touchstart', handle_touch_start, false);
      document.addEventListener('touchmove', handle_touch_move, false);
    
    
      const handle_mousemove = (width, height) => (e) =>
      {
        follow_cursor.style.left = e.pageX - width / 2 + 'px';
        follow_cursor.style.top = e.pageY - height / 2 + 'px';
      };
    
      let follow_cursor = document.getElementsByClassName('follow_cursor');
      follow_cursor = follow_cursor[0];
    
      let follow_cursor_width = follow_cursor.getBoundingClientRect().width;
      let follow_cursor_height = follow_cursor.getBoundingClientRect().height;
    
      let listener_mousemove;
    
      let tl_follow_cursor = gsap.timeline(), tl_follow_cursor_cld = gsap.timeline();

      tl_follow_cursor.set(follow_cursor, {opacity: 1});
    
      if ('ontouchstart' in window)
      {
        const follow_cursor_duration = 4.5;
    
        tl_follow_cursor.set(follow_cursor, {x: (window_width - follow_cursor_width) / 2, y: (window_height - follow_cursor_height) / 2});
    
        let end_point = [get_random_int(-follow_cursor_width / 2, window_width - follow_cursor_width / 2), get_random_int(-follow_cursor_height, window_height - follow_cursor_height / 2)];
      
        function follow_cursor_animation()
        {
          end_point = [get_random_int(-follow_cursor_width / 2, window_width - follow_cursor_width / 2), get_random_int(-follow_cursor_height / 2, window_height - follow_cursor_height / 2)];
      
          tl_follow_cursor_cld.to(follow_cursor, { duration: follow_cursor_duration, ease: "power2.inOut",
            motionPath:
            {
              path: [{ x: end_point[0], y: end_point[1] }],
            }
          });
        }
      
        tl_follow_cursor.to({}, {duration: follow_cursor_duration, repeat: -1,
          onStart: follow_cursor_animation,
          onRepeat: follow_cursor_animation,
        });
      }
      else
      {
        follow_cursor.style.left = (window_width - follow_cursor_width) / 2 + 'px';
        follow_cursor.style.top = (window_height - follow_cursor_height) / 2 + 'px';
      
        listener_mousemove = handle_mousemove(follow_cursor_width, follow_cursor_height);
        document.addEventListener('mousemove', listener_mousemove);
      }
    
    
      const delay_back_board = 5;
      const duration_back_board = 1;
    
      // const back_board_amount_images = 11;
    
      // let back_board_images = [];
      // for (let i = 1; i <= back_board_amount_images; i++)
      // {
      //   back_board_images.push(`back_board_chip_${i}.svg`);
      // }
    
      let back_board_chips = document.getElementsByClassName('back_board-chips');
      back_board_chips = back_board_chips[0];
    
      let tl_back_board_chips = gsap.timeline();
      tl_back_board_chips.set(back_board_chips, {opacity: .9});
    
      function back_board_chips_animation()
      {
        let tl_back_board_chips_lit = gsap.timeline();
        tl_back_board_chips_lit.to(back_board_chips, {delay: delay_back_board, duration: duration_back_board / 2, ease: 'power1.in', opacity: .45});
        tl_back_board_chips_lit.to(back_board_chips, {delay: 0, duration: duration_back_board / 2, ease: 'power1.out', opacity: .9});
      }
    
      tl_back_board_chips.to({}, {delay: 0, duration: delay_back_board + duration_back_board, repeat: -1,
        onStart: back_board_chips_animation,
        onRepeat: back_board_chips_animation,
      })
      
      // let back_board_ind = 0;
      // back_board_images.forEach((image) =>
      // {
      //   const back_board_chip = document.createElement('div');
      //   back_board_chip.classList.add('back_board-chip');
      //   back_board_chip.style.backgroundImage = `url('../images/back_board_chips_pack/${image}')`;
      //   back_board_chips.appendChild(back_board_chip);
      //   let tl_back_board_chip = gsap.timeline();
      //   tl_back_board_chip.set(back_board_chip, {opacity: .8});
    
      //   function back_board_chip_animation()
      //   {
      //     let tl_back_board_chip_lit = gsap.timeline();
      //     tl_back_board_chip_lit.to(back_board_chip, {duration: duration_back_board / 3, ease: 'power1.in', opacity: .5});
      //     tl_back_board_chip_lit.to(back_board_chip, {delay: duration_back_board / 3, duration: duration_back_board / 3, ease: 'power1.out', opacity: .85});
      //   }
    
      //   tl_back_board_chip.to({}, {delay: back_board_ind * delay_back_board, duration: duration_back_board, repeat: -1,
      //     onStart: back_board_chip_animation,
      //     onRepeat: back_board_chip_animation,
      //   })
      //   back_board_ind++;
      // });
    
      
      let main_logo_back = document.getElementsByClassName('main-logo_back');
      main_logo_back = main_logo_back[0];
    
      let main_logo = document.getElementsByClassName('main-logo');
      main_logo = main_logo[0];
    
      let els = document.getElementsByClassName('pixel-k');
      els = els[0];
    
      let els_width = els.getBoundingClientRect().width;
      let els_height = els.getBoundingClientRect().height;

      const els_grid_rows = window.getComputedStyle(els).getPropertyValue('grid-template-rows').split(' ').length;
      const els_grid_columns = window.getComputedStyle(els).getPropertyValue('grid-template-columns').split(' ').length;

      let els_translateY_for_center = (window_height - els_height) / 2;
      let els_translateX_for_center = (window_width - els_width) / 2;
    
      let els_1_x_1 = els_translateX_for_center;
      let els_1_x_2 = 0;
      let els_1_x_3 = els_translateX_for_center / 5;
      let els_1_x_4 = els_translateX_for_center / 6;
    
    
      let proff_logo = document.getElementsByClassName('proff-logo');
      proff_logo = proff_logo[0];

      let proff_logo_letter = document.getElementsByClassName('proff-logo-letter');
      proff_logo_letter = proff_logo_letter[0];
    
      let proff_logo_width = proff_logo.getBoundingClientRect().width;
      let proff_logo_height = proff_logo.getBoundingClientRect().height;
    
      let angle_shift = -10;
      
      let proff_logo_x_1 = window_width;
      let proff_logo_y_1 = els_height + els_translateY_for_center - proff_logo_height;
      let proff_logo_x_2 = els_width + els_1_x_3;
      let proff_logo_angle_1 = (proff_logo_x_1 - proff_logo_x_2) / (Math.PI * getMaxNumber(proff_logo_width, proff_logo_height)) * 360 + angle_shift;
      let proff_logo_angle_2 = angle_shift;
    
      let proff_logo_angle_3 = 0;
      let proff_logo_x_3 = proff_logo_x_2 + Math.PI * getMaxNumber(proff_logo_width, proff_logo_height) * (-angle_shift / 360);
    
    
      let logo_letters = document.getElementsByClassName('logo-letters');
      logo_letters = logo_letters[0];
    
      let logo_letters_width = window_width - (proff_logo_x_3 + proff_logo_width) - (proff_logo_x_3 - els_width);
      let logo_letters_height = proff_logo_height;
    
      let logo_letters_x_1 = window_width - logo_letters_width - els_1_x_4;
      let logo_letters_y_1 = els_height + els_translateY_for_center - logo_letters_height;
    
      let all_logo_letter = Array.from(logo_letters.getElementsByClassName('logo-letter'));
      let all_logo_letter_width = 0;
      all_logo_letter.forEach(logo_letter =>
      {
        all_logo_letter_width += logo_letter.getBoundingClientRect().width;
      });
    
      let logo_letter_font_size = parseInt(window.getComputedStyle(all_logo_letter[0]).getPropertyValue('font-size'));
      let coeff_font_size = logo_letter_font_size / all_logo_letter_width;
      let logo_letter_new_font_size = coeff_font_size * logo_letters_width;
    
      const delay_1_1 = .5, delay_1_2 = .2;
      const delay_2_1 = .6, delay_2_2 = .35, delay_2_3 = .05;
      const delay_2_4 = .15, delay_2_5 = .3;
    
      const duration_1_1 = 1.1, duration_1_2 = .4, duration_1_3 = .45;
      const duration_2_1 = (delay_1_1 + duration_1_1) + (duration_1_2 + delay_1_2) - delay_2_1,
            duration_2_1_freq = .04, duration_2_1_lit = .1;
      const duration_2_2 = .75;
      const duration_2_3 = .45, duration_2_3_lit = .5,
            duration_2_4 = .7;
      const duration_2_5 = 1.75;
      const duration_2_5_lit = duration_2_5 / 2;
    
      const index_need_pixel = [0, 3, 4, 6, 8, 9, 12, 14, 16, 19];
      const index_pixel = Array.from({length: 20}, (_, i) => i);
      const index_not_need_pixel = index_pixel.filter(num => !index_need_pixel.includes(num));
    
    
      const delay_proff_logo_1 = delay_2_1 + duration_2_1, delay_proff_logo_2 = .01, delay_proff_logo_3 = .1;
      const auto_delay_proff_logo = 5;

      const duration_proff_logo_1 = delay_2_2 + duration_2_2, duration_proff_logo_2 = 1.5,  duration_proff_logo_3 = 1.25;
    
      let tl_proff_logo = gsap.timeline();
      tl_proff_logo.set(proff_logo, {opacity: 1, x: window_width, y: window_height});
      tl_proff_logo.fromTo(proff_logo, {x: proff_logo_x_1, y: proff_logo_y_1, rotate: proff_logo_angle_1}, { delay: delay_proff_logo_1, duration: duration_proff_logo_1, ease: 'none', x: proff_logo_x_2, y: proff_logo_y_1, rotate: proff_logo_angle_2});
      tl_proff_logo.to(proff_logo, {delay: delay_proff_logo_2, duration: duration_proff_logo_2, ease: 'power2.out', x: proff_logo_x_3, rotate: proff_logo_angle_3});
      tl_proff_logo.to(proff_logo, {delay: delay_proff_logo_3, duration: duration_proff_logo_3 / 2, ease: 'power2.in', rotationY: 90,
        onComplete: function()
        {
          gsap.set(proff_logo, {backgroundImage: 'none', backgroundColor: 'black'});
          gsap.set(proff_logo_letter, {opacity: 1, fontSize: logo_letter_new_font_size, rotationY: -180});
        }
      });
      tl_proff_logo.to(proff_logo, {delay: 0, duration: duration_proff_logo_3 / 2, ease: 'power2.out', rotationY: 180});

      let tl_proff_logo_lit = gsap.timeline();
      let auto_proff_logo_flag = {fl: true};

      function animate_auto_proff_logo()
      {
        let need_background_image = 'none', need_background_color = 'black', need_opacity = 1, need_rotation_y = 180;

        if (auto_proff_logo_flag.fl == true)
        {
          need_background_image = `url(images/Avatar_Cyber.svg)`;
          need_background_color = base_color_1;
          need_opacity = 0;
          need_rotation_y = 360;
        }
        auto_proff_logo_flag.fl = !auto_proff_logo_flag.fl;

        tl_proff_logo_lit.to(proff_logo, {delay: 0, duration: duration_proff_logo_3 / 2, ease: 'power2.in', rotationY: (need_rotation_y - 90),
          onComplete: function()
          {
            gsap.set(proff_logo, {backgroundImage: need_background_image, backgroundColor: need_background_color});
            gsap.set(proff_logo_letter, {opacity: need_opacity});
          }
        });

        tl_proff_logo_lit.to(proff_logo, {delay: 0, duration: duration_proff_logo_3 / 2, ease: 'power2.out', rotationY: need_rotation_y});
        if (need_rotation_y == 360)
        {
          tl_proff_logo_lit.set(proff_logo, {rotationY: 0});
        }
      }

      tl_proff_logo.to({}, {duration: auto_delay_proff_logo, repeat: -1,
        onRepeat: animate_auto_proff_logo
      });


      let tl_logo_letters = gsap.timeline();
      tl_logo_letters.set(logo_letters, {width: logo_letters_width, height: logo_letters_height, x: logo_letters_x_1, y: logo_letters_y_1, color: 'white'});
    
      const logo_letters_colors = [base_color_1, 'rgba(255, 255, 255, .35)'];

      const delay_logo_letters_1 = 2.5, each_logo_letters_1 = .075
      const duration_logo_letters_2 = .2, duration_logo_letters_2_lit = .5;
      
      let all_logo_letter_object = {list: []};
      let tl_all_logo_letter_lit = [];
      let tl_all_logo_letter = gsap.timeline();

      for(let i = 0; i < all_logo_letter.length; i++)
      {
        all_logo_letter_object.list.push(false);
        tl_all_logo_letter_lit.push(gsap.timeline());
      }

      tl_all_logo_letter.set(all_logo_letter, {opacity: 0, fontSize: logo_letter_new_font_size, scale: .5, rotate: 15});
      tl_all_logo_letter.to(all_logo_letter, {delay: delay_logo_letters_1, ease: 'none', opacity: 1, scale: 1, rotate: 0,
        stagger: 
        {
          each: each_logo_letters_1,
          from: "end"
        }
      });

      tl_all_logo_letter.to({}, {duration: duration_logo_letters_2, repeat: -1,
        onRepeat: function()
        {
          const logo_letters_rand_ind_color = Math.floor(Math.random() * logo_letters_colors.length);
          const logo_letters_rand_color = logo_letters_colors[logo_letters_rand_ind_color];
          
          let logo_letters_false = all_logo_letter_object.list.map((el, ind) => ({ el, ind })).filter(({ ind }) => all_logo_letter_object.list[ind] === false).map(({ ind }) => ind);
          if (logo_letters_false.length > 0)
          {
            let random_ind_logo_letter_false = logo_letters_false[Math.floor(Math.random() * logo_letters_false.length)];
            all_logo_letter_object.list[random_ind_logo_letter_false] = true;

            tl_all_logo_letter_lit[random_ind_logo_letter_false].to(all_logo_letter[random_ind_logo_letter_false], {duration: duration_logo_letters_2_lit, ease: 'power1.in', color: logo_letters_rand_color});
            tl_all_logo_letter_lit[random_ind_logo_letter_false].to(all_logo_letter[random_ind_logo_letter_false], {duration: duration_logo_letters_2_lit, ease: 'power1.out', color: 'white',
              onComplete: function()
              {
                all_logo_letter_object.list[random_ind_logo_letter_false] = false;
              }
            });
          }
        }
      });



      // function fun_els_in_1()
      // {
      //   let indices_false_els = an_object.list.map((el, ind) => ({ el, ind })).filter(({ ind }) => an_object.list[ind] === false).map(({ ind }) => ind);
      //   if (indices_false_els.length > 0)
      //   {
      //     let random_ind_false_el = indices_false_els[Math.floor(Math.random() * indices_false_els.length)];
      //     let el_border_radius = window.getComputedStyle(el[random_ind_false_el]).getPropertyValue('border-radius');
      //     an_object.list[random_ind_false_el] = true;

      //     let needRadius, needColor_0, needColor_1;
      //     if (el_border_radius === '0%')
      //     {
      //       needRadius = 50;
      //       needColor_0 = base_color_0;
      //       needColor_1 = base_color_1;
      //     }
      //     else
      //     {
      //       needRadius = 0;
      //       needColor_0 = 'rgba(255, 255, 255, 0)';
      //       needColor_1 = 'white';
      //     }
      //     tl_els_in_2s[random_ind_false_el].to(el[random_ind_false_el], {duration: duration_2_1_lit, ease: 'power1.in', backgroundColor: needColor_1, borderRadius: 25, borderColor: needColor_1});
      //     tl_els_in_2s[random_ind_false_el].to(el[random_ind_false_el], {duration: duration_2_1_lit, ease: 'power1.out', backgroundColor: needColor_0, borderRadius: needRadius,
      //       onComplete: function()
      //       {
      //         an_object.list[random_ind_false_el] = false;
      //       }
      //     });
      //   }
      // }


      // an_object.list.forEach((el, ind) =>
      // {
      //   an_object.list[ind] = false;
      // });

      // tl_els_in_1 = gsap.timeline();
      // tl_els_in_1.to({}, {duration: duration_2_1_freq, repeat: -1, onRepeat: fun_els_in_1});





      // tl_all_logo_letter.to({}, {duration: 2, repeat: -1,
      //   onRepeat: function()
      //   {
      //     const all_logo_letter_rand_ind = Math.floor(Math.random() * all_logo_letter.length);
      //     let rand_logo_letter = all_logo_letter[all_logo_letter_rand_ind];
      //     tl_all_logo_letter_lit.to(rand_logo_letter, {duration: duration_logo_letters_lit / 2, ease: 'power2.in', color: base_color_1});
      //     tl_all_logo_letter_lit.to(rand_logo_letter, {duration: duration_logo_letters_lit / 2, ease: 'power2.out', color: 'white'});
      //   }
      // });
      
      
      const delay_main_logo_1 = delay_2_1 + duration_2_1;
      const duration_main_logo_1 = .125, duration_main_logo_2 = .125;
    
      let tl_main_logo = gsap.timeline();
    
      tl_main_logo.set(main_logo, {rotate: 0});
      tl_main_logo.to(main_logo, {delay: delay_main_logo_1, duration: duration_main_logo_1, ease: 'none', rotate: 3});
      tl_main_logo.to(main_logo, {delay: 0, duration: duration_main_logo_2, ease: 'none', rotate: 0});
      
      
      const delay_main_logo_back_1 = delay_2_1 + duration_2_1;
      const duration_main_logo_back_1 = .25;
    
      let tl_main_logo_back = gsap.timeline();
    
      tl_main_logo_back.set(main_logo_back, {backgroundColor: 'rgba(255, 255, 255, 0)'});
      tl_main_logo_back.to(main_logo_back, {delay: delay_main_logo_back_1, duration: duration_main_logo_back_1 / 10, ease: 'power2.in', backgroundColor: 'rgba(255, 255, 255, .3)'});
      tl_main_logo_back.to(main_logo_back, {delay: 0, duration: duration_main_logo_back_1 * 9 / 10, ease: 'power2.out', backgroundColor: 'rgba(255, 255, 255, 0)'});
    
      let tl_els_1 = gsap.timeline(), tl_els_2 = gsap.timeline();
      let tl_els_in_1, tl_els_in_2s = [];
    
      let el = document.getElementsByClassName('pixel');
      let an_object = {list: []};
      for(let i = 0; i < el.length; i++)
      {
        el[i].style.borderRadius = '0%';
        an_object.list.push(false);
        tl_els_in_2s.push(gsap.timeline());
      }
    
      let el_square = [], el_circle = [];
      let el_square_right_diagonals = [];
      for (let i = 0; i < els_grid_rows + els_grid_columns - 1; i++)
      {
        el_square_right_diagonals.push([]);
      }
    
      tl_els_1.fromTo(els, {x: els_1_x_1, scale: .5, backgroundColor: 'rgba(0, 0, 0, 0)'}, {delay: delay_1_1, duration: duration_1_1, ease: 'power2.inOut', scale: 1, backgroundColor: 'black'});
      tl_els_1.to(els, {delay: delay_1_2, duration: duration_1_2, ease: 'power3.in', x: els_1_x_2});
      tl_els_1.to(els, {duration: duration_1_3, ease: 'power3.Out', x: els_1_x_3});
    
    
      tl_els_2.to({}, { delay: delay_2_1, duration: duration_2_1,
        onStart: function()
        {
          function fun_els_in_1()
          {
            let indices_false_els = an_object.list.map((el, ind) => ({ el, ind })).filter(({ ind }) => an_object.list[ind] === false).map(({ ind }) => ind);
            if (indices_false_els.length > 0)
            {
              let random_ind_false_el = indices_false_els[Math.floor(Math.random() * indices_false_els.length)];
              let el_border_radius = window.getComputedStyle(el[random_ind_false_el]).getPropertyValue('border-radius');
              an_object.list[random_ind_false_el] = true;
    
              let needRadius, needColor_0, needColor_1;
              if (el_border_radius === '0%')
              {
                needRadius = 50;
                needColor_0 = base_color_0;
                needColor_1 = base_color_1;
              }
              else
              {
                needRadius = 0;
                needColor_0 = 'rgba(255, 255, 255, 0)';
                needColor_1 = 'white';
              }
              tl_els_in_2s[random_ind_false_el].to(el[random_ind_false_el], {duration: duration_2_1_lit, ease: 'power1.in', backgroundColor: needColor_1, borderRadius: 25, borderColor: needColor_1});
              tl_els_in_2s[random_ind_false_el].to(el[random_ind_false_el], {duration: duration_2_1_lit, ease: 'power1.out', backgroundColor: needColor_0, borderRadius: needRadius,
                onComplete: function()
                {
                  an_object.list[random_ind_false_el] = false;
                }
              });
            }
          }
    
    
          an_object.list.forEach((el, ind) =>
          {
            an_object.list[ind] = false;
          });
    
          tl_els_in_1 = gsap.timeline();
          tl_els_in_1.to({}, {duration: duration_2_1_freq, repeat: -1, onRepeat: fun_els_in_1});
        },
        onComplete: function()
        {
          tl_els_in_1.clear();
    
          for(let ind = 0; ind < el.length; ind++)
          {
            tl_els_in_2s[ind].clear();
            el_border_radius = window.getComputedStyle(el[ind]).getPropertyValue('border-radius');
            if (el_border_radius <= '25%')
            {
              el[ind].style.borderRadius = '0%';
              el[ind].style.borderColor = 'white';
              el[ind].style.backgroundColor = 'white';
              el_square.push(el[ind]);
            }
            else
            {
              el[ind].style.borderRadius = '50%';
              el[ind].style.borderColor = base_color_1;
              el[ind].style.backgroundColor = base_color_1;
              el_circle.push(el[ind]);
            }
          }
        }
      });
    
      tl_els_2.addLabel('option_1');
      tl_els_2.to({}, {delay: delay_2_2, duration: duration_2_2,
        onStart: function()
        {
          let selected_el = [], not_selected_el = [];
          if (index_need_pixel.length > el_circle.length)
          {
            let copy_el_square = el_square.slice();
            copy_el_square = mix_list(copy_el_square);
            selected_el = copy_el_square.slice(0, copy_el_square.length - index_need_pixel.length);
            not_selected_el = copy_el_square.slice(copy_el_square.length - index_need_pixel.length, copy_el_square.length);
    
            selected_el.forEach((el, ind) =>
            {
              gsap.to(el, {duration: duration_2_2, ease: 'power2.inOut', backgroundColor: base_color_1, borderColor: base_color_1, borderRadius: 50});
            });
    
            el_circle = el_circle.concat(selected_el);
          }
          else if (index_need_pixel.length < el_circle.length)
          {
            let copy_el_circle = mix_list(el_circle.slice());
            selected_el = copy_el_circle.slice(0, copy_el_circle.length - index_need_pixel.length);
            not_selected_el = copy_el_circle.slice(copy_el_circle.length - index_need_pixel.length, copy_el_circle.length);
    
            selected_el.forEach((el, ind) =>
            {
              gsap.to(el, {duration: duration_2_2, ease: 'power2.inOut', backgroundColor: 'white', borderColor: 'white', borderRadius: 0});
            });
    
            el_circle = not_selected_el;
          }
          else
          {
            // tl_els_2.play('option_2');
          }
        }
      });
    
    
      tl_els_2.addLabel('option_2');
      tl_els_2.to({}, {delay: delay_2_3, duration: duration_2_3,
        onStart: function()
        {
          tl_els_in_2s = gsap.timeline();
          tl_els_in_2s.to(els, {duration: duration_2_3_lit, ease: 'power2.out', x: els_1_x_4});
          
          el_circle.forEach((el, ind) =>
          {
            gsap.to(el, {duration: duration_2_3, ease: 'power1.out', backgroundColor: base_color_0});
          });
        }
      });
    
      tl_els_2.to({}, {delay: delay_2_4, duration: duration_2_4,
        onStart: function()
        {
          let amount_el_circle = 0;
    
          let copy_index_need_pixel = mix_list(index_need_pixel.slice());
          let copy_index_not_need_pixel = mix_list(index_not_need_pixel.slice());
    
          let list_pair_square_circle = [];
          for (let i = 0; i < copy_index_need_pixel.length; i++)
          {
            let el_border_radius = window.getComputedStyle(el[copy_index_need_pixel[i]]).getPropertyValue('border-radius');
    
            if (el_border_radius === '50%')
            {
              amount_el_circle++;
              if (copy_index_not_need_pixel.length > 0)
              {
                let one_el_square = copy_index_not_need_pixel.shift();
                el_border_radius = window.getComputedStyle(el[one_el_square]).getPropertyValue('border-radius');
    
                let error_length_fl = false;
                while (el_border_radius === '50%' && !error_length_fl)
                {
                  if (copy_index_not_need_pixel.length > 0)
                  {
                    one_el_square = copy_index_not_need_pixel.shift();
                    el_border_radius = window.getComputedStyle(el[one_el_square]).getPropertyValue('border-radius');
                  }
                  else
                  {
                    error_length_fl = true;
                  }
                }
    
                if (!error_length_fl)
                {
                  list_pair_square_circle.push([el[one_el_square], el[copy_index_need_pixel[i]]]);
                }
              }
            }
          }
    
          const duration_2_4_lit = duration_2_4 / amount_el_circle;
    
          list_pair_square_circle.forEach((pair_square_circle, ind) =>
          {
            gsap.to(pair_square_circle[0], {delay: ind * duration_2_4_lit, duration: duration_2_4_lit, ease: 'power1.inOut', backgroundColor: base_color_0, borderColor: base_color_1, borderRadius: 50});
            gsap.to(pair_square_circle[1], {delay: ind * duration_2_4_lit, duration: duration_2_4_lit, ease: 'power1.inOut', backgroundColor: 'white', borderColor: 'white', borderRadius: 0});
          });
    
        }
      });
    
      tl_els_2.to({}, {delay: delay_2_5, duration: duration_2_5,
        onStart: function()
        {
          let el_square_pos_x, el_square_pos_y;
          let delta_delay_2_5_lit = (duration_2_5 - duration_2_5_lit) / (els_grid_rows + els_grid_columns - 1);
          if (delta_delay_2_5_lit < 0)
          {
            delta_delay_2_5_lit = 0;
          }

          el_circle = [];
          for (let i = 0; i < el.length; i++)
          {
            let el_border_radius = window.getComputedStyle(el[i]).getPropertyValue('border-radius');
            if (el_border_radius === '50%')
            {
              el_circle.push(el[i]);
            }
            else
            {
              el_square_pos_y = Math.floor(i / els_grid_columns);
              el_square_pos_x = i - el_square_pos_y * els_grid_columns;
              el_square_right_diagonals[el_square_pos_x + el_square_pos_y].push(el[i]);
            }
          }

          let j = 0;
          el_square_right_diagonals.forEach((el_square_right_diagonal, ind) =>
          {
            el_square_right_diagonal.forEach((el_square, lit_ind) =>
            {
              gsap.to(el_square, {delay: j * delta_delay_2_5_lit, duration: duration_2_5_lit, ease: 'none', repeat: -1, yoyo: true, backgroundColor: base_color_1, borderColor: base_color_1});
            });
            j += 1;
          });
          
          el_circle.forEach((el, ind) =>
          {
            gsap.to(el, {duration: duration_2_5, ease: 'power2.out', borderColor: base_color_0});
          });


          // for (let i = 0; i < el.length; i++)
          // {
          //   let el_border_radius = window.getComputedStyle(el[i]).getPropertyValue('border-radius');

          // }

        },
        onComplete: function()
        {
          logo_animation_flag.fl = true;
        }
      });
    
      
      window.addEventListener('resize', function()
      {
        follow_cursor_width = follow_cursor.getBoundingClientRect().width;
        follow_cursor_height = follow_cursor.getBoundingClientRect().height;
        
        if (!('ontouchstart' in window))
        {
          if (listener_mousemove)
          {
            document.removeEventListener('mousemove', handle_mousemove);
          }
          listener_mousemove = handle_mousemove(follow_cursor_width, follow_cursor_height);
          document.addEventListener('mousemove', handle_mousemove);
        }
    
    
        if (window_aspect_ratio > 1)
        {
          
        }
        else
        {
          
        }
    
    
        if (logo_animation_flag.fl == true)
        {
          window_width = window.innerWidth;
          window_height = window.innerHeight;
    
          els_width = els.getBoundingClientRect().width;
          els_height = els.getBoundingClientRect().height;
        
          els_translateX_for_center = (window_width - els_width) / 2;
          els_translateY_for_center = (window_height - els_height) / 2;
    
          els_1_x_3 = els_translateX_for_center / 5;
          els_1_x_4 = els_translateX_for_center / 6;
        
          gsap.set(els, {x: els_1_x_4});
    
        
          proff_logo_width = proff_logo.getBoundingClientRect().width;
          proff_logo_height = proff_logo.getBoundingClientRect().height;
          
          proff_logo_y_1 = els_height + els_translateY_for_center - proff_logo_height;
          proff_logo_x_2 = els_width + els_1_x_3;
          proff_logo_x_3 = proff_logo_x_2 + Math.PI * getMaxNumber(proff_logo_width, proff_logo_height) * (-angle_shift / 360);
    
          gsap.set(proff_logo, {x: proff_logo_x_3, y: proff_logo_y_1});
    
    
          logo_letters_width = window_width - (proff_logo_x_3 + proff_logo_width) - (proff_logo_x_3 - els_width);;
          logo_letters_height = proff_logo_height;
        
          logo_letters_x_1 = window_width - logo_letters_width - els_1_x_4;
          logo_letters_y_1 = els_height + els_translateY_for_center - logo_letters_height;
    
          gsap.set(logo_letters, {width: logo_letters_width, height: logo_letters_height, x: logo_letters_x_1, y: logo_letters_y_1});
    
          logo_letter_new_font_size = coeff_font_size * logo_letters_width;
    
          gsap.set(all_logo_letter, {fontSize: logo_letter_new_font_size});
          gsap.set(proff_logo_letter, {fontSize: logo_letter_new_font_size});
        }
      });
    }
  });



});

