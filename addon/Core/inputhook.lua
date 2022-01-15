-------------------
-- Input hook functions for ni
local ni = ...

ni.inputhook = {}

-- Localization to avoid hooks
-- FIXME: remove if no localization needed, or replace with what is needed
local something

--- virtual key table
ni.keys = {
   LBUTTON = 0x01, -- Left mouse button
   RBUTTON = 0x02, -- Right mouse button
   CANCEL = 0x03, -- Control-break processing
   MBUTTON = 0x04, -- Middle mouse button (three-button mouse)
   XBUTTON1 = 0x05, -- X1 mouse button
   XBUTTON2 = 0x06, -- X2 mouse button
   BACK = 0x08, -- BACKSPACE key
   TAB = 0x09, -- TAB key
   CLEAR = 0x0C, -- CLEAR key
   RETURN = 0x0D, -- ENTER key
   SHIFT = 0x10, -- SHIFT key
   CONTROL = 0x11, -- CTRL key
   MENU = 0x12, -- ALT key
   PAUSE = 0x13, -- PAUSE key
   CAPITAL = 0x14, -- CAPS LOCK key
   ESCAPE = 0x1B, -- ESC key
   SPACE = 0x20, -- SPACEBAR
   PRIOR = 0x21, -- PAGE UP key
   NEXT = 0x22, -- PAGE DOWN key
   END = 0x23, -- END key
   HOME = 0x24, -- HOME key
   LEFT = 0x25, -- LEFT ARROW key
   UP = 0x26, -- UP ARROW key
   RIGHT = 0x27, -- RIGHT ARROW key
   DOWN = 0x28, -- DOWN ARROW key
   SELECT = 0x29, -- SELECT key
   PRINT = 0x2A, -- PRINT key
   EXECUTE = 0x2B, -- EXECUTE key
   SNAPSHOT = 0x2C, -- PRINT SCREEN key
   INSERT = 0x2D, -- INS key
   DELETE = 0x2E, -- DEL key
   HELP = 0x2F, -- HELP key
   ["0"] = 0x30, -- 0 key
   ["1"] = 0x31, -- 1 key
   ["2"] = 0x32, -- 2 key
   ["3"] = 0x33, -- 3 key
   ["4"] = 0x34, -- 4 key
   ["5"] = 0x35, -- 5 key
   ["6"] = 0x36, -- 6 key
   ["7"] = 0x37, -- 7 key
   ["8"] = 0x38, -- 8 key
   ["9"] = 0x39, -- 9 key
   A = 0x41, -- A key
   B = 0x42, -- B key
   C = 0x43
}

