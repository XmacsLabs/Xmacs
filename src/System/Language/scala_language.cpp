
/******************************************************************************
* MODULE     : scala_language.cpp
* DESCRIPTION: the Scala language
* COPYRIGHT  : (C) 2014-2020  François Poulain, Darcy Shen
*******************************************************************************
* This software falls under the GNU general public license and comes WITHOUT
* ANY WARRANTY WHATSOEVER. See the file $TEXMACS_PATH/LICENSE for more details.
* If you don't have this file, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
******************************************************************************/

#include "analyze.hpp"
#include "impl_language.hpp"
#include "scheme.hpp"

scala_language_rep::scala_language_rep (string name):
  abstract_language_rep (name)
{
  number_parser.use_scala_style ();

  array<string> starts;
  starts << string("//");
  inline_comment_parser.set_starts (starts);

  array<char> escape_chars;
  escape_chars << '\\' << '\'' << '\"'
    << 'b' << 'f' << 'n' << 'r' << 't';
  escaped_char_parser.set_chars (escape_chars);
  escaped_char_parser.support_hex_with_16_bits (true);

  string_parser.set_escaped_char_parser (escaped_char_parser);
  hashmap<string, string> pairs;
  pairs("\"") = "\"";
  pairs("\"\"\"") = "\"\"\"";
  pairs("\'")= "\'";
  string_parser.set_pairs(pairs);

  array<char> start_chars, extra_chars;
  // The ‘$’ character is reserved for compiler-synthesized identifiers.
  start_chars << '_' << '$';
  extra_chars << '_';
  identifier_parser.set_start_chars (start_chars);
  identifier_parser.set_extra_chars (extra_chars);

  keyword_parser.use_keywords_of_lang (name);
  operator_parser.use_operators_of_lang (name);
}

text_property
scala_language_rep::advance (tree t, int& pos) {
  string s= t->label;
  if (pos==N(s))
    return &tp_normal_rep;

  if (blanks_parser.parse (s, pos))
    return &tp_space_rep;
  if (escaped_char_parser.parse (s, pos))
    return &tp_normal_rep;
  if (number_parser.parse (s, pos))
    return &tp_normal_rep;
  if (identifier_parser.parse (s, pos))
    return &tp_normal_rep;

  tm_char_forwards (s, pos);
  return &tp_normal_rep;
}

array<int>
scala_language_rep::get_hyphens (string s) {
  int i;
  array<int> penalty (N(s)+1);
  penalty[0]= HYPH_INVALID;
  for (i=1; i<N(s); i++)
    if (s[i-1] == '-' && is_alpha (s[i]))
      penalty[i]= HYPH_STD;
    else penalty[i]= HYPH_INVALID;
  penalty[i]= HYPH_INVALID;
  return penalty;
}

void
scala_language_rep::hyphenate (
  string s, int after, string& left, string& right)
{
  left = s (0, after);
  right= s (after, N(s));
}

string
scala_language_rep::get_color (tree t, int start, int end) {
  static string none= "";
  if (start >= end) return none;
  if (in_comment (start, t))
    return decode_color ("scala", encode_color ("comment"));

  string s= t->label;
  int pos= 0;
  int opos= 0;
  string type;
  string_parser.reset ();

  do {
    type= none;
    do {
      opos= pos;

      if (string_parser.unfinished ()) {
        if (string_parser.escaped () && string_parser.parse_escaped (s, pos)) {
          type= "constant_char";
          break;
        }
        if (string_parser.parse (s, pos)) {
          type= "constant_string";
          break;
        }
      }

      if (blanks_parser.parse (s, pos)) break;
      if (inline_comment_parser.parse (s, pos)) {
        type= "comment";
        break;
      }
      if (string_parser.parse (s, pos)) {
        type= "constant_string";
        break;
      }
      if (keyword_parser.parse (s, pos)) {
        string keyword= s(opos, pos);
        type= keyword_parser.get (keyword);
        break;
      }
      if (number_parser.parse (s, pos)) {
        type= "constant_number";
        break;
      }
      if (operator_parser.parse (s, pos)) {
        string oper= s(opos, pos);
        type= operator_parser.get (oper);
        break;
      }
      parse_identifier (colored, s, pos);
      if (opos < pos) {
        type= none;
        break;
      }
      
      pos= opos;
      pos++;
    } while (false);
  } while (pos <= start);

  if (type == none) return none;
  return decode_color ("scala", encode_color (type));
}
