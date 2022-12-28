module SpecDiscover

import Data.String
import Data.Either
import Data.Maybe
import System
import System.File
import System.Path
import System.Directory.Tree

partial
main : IO ()
main = do
  [_, dir] <- getArgs
  tr <- explore (parse dir)
  let allFiles = files $ filter (\fn => "Spec.idr" `isSuffixOf` (fileName fn)) (\_ => True) tr
  let specFiles = map fileName allFiles
  let specs = map (\s => fst $ String.break (== '.') s) specFiles
  f <- openFile "\{dir}/Main.idr" WriteTruncate
  let file = case f of
               Right f => f
  _ <- fPutStrLn file "module Main"
  _ <- fPutStrLn file $ unlines (map (\s => "import \{s}") specs)
  _ <- fPutStrLn file "main : IO ()"
  _ <- fPutStrLn file "main = do"
  _ <- fPutStrLn file $ unlines (map (\s => "  run $ new emptyState \{s}.spec") specs)
  fflush file
  closeFile file

  f <- openFile "\{dir}/test.ipkg" WriteTruncate
  let file = case f of
               Right f => f
  _ <- fPutStrLn file "package mesnrklesbkbdsjfbdkfjbdskjfds"
  _ <- fPutStrLn file "depends = control-spec, contrib"
  _ <- fPutStrLn file "main = Main"
  _ <- fPutStrLn file "executable = runAllTests"
  _ <- fPutStrLn file $ "modules = " ++ unwords specs
  fflush file
  closeFile file
