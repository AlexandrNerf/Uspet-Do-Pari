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

document.addEventListener('DOMContentLoaded', function()
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
            tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', backgroundColor: 'rgba(0,0,0,0)'});
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
            tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', backgroundColor: 'black'});
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
          tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', backgroundColor: 'rgba(0,0,0,0)'});
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
          tl_blur.to(filter_need, { duration: duration_scroll, ease: 'power2.inOut', backgroundColor: 'black'});
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
});

