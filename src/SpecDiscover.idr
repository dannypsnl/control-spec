module SpecDiscover

import Control.App
import Control.App.FileIO
import Data.String
import Data.Either
import Data.Maybe
import System
import System.File
import System.Path
import System.Directory.Tree
import Text.PrettyPrint.Prettyprinter.Doc
import Text.PrettyPrint.Prettyprinter.Render.Terminal

putIOError : PrimIO e => IOError -> App e a
putIOError e = primIO ((putDoc $ pretty $ show e) *> exitSuccess)

mainModule : FileIO e => List String -> File -> App e ()
mainModule specs file = do
  fPutStrLn file "module Main"
  fPutStrLn file $ unlines (map (\s => "import \{s}") specs)
  fPutStrLn file "main : IO ()"
  fPutStrLn file "main = do run (new emptyState (do"
  fPutStrLn file $ unlines (map (\s => "  \{s}.spec") specs)
  fPutStrLn file "  specFinalReport))"
  fflush file

ipkgTest : FileIO e => List String -> File -> App e ()
ipkgTest specs file = do
  fPutStrLn file "package mesnrklesbkbdsjfbdkfjbdskjfds"
  fPutStrLn file "depends = control-spec, contrib"
  fPutStrLn file "main = Main"
  fPutStrLn file "executable = runAllTests"
  fPutStrLn file $ "modules = " ++ joinBy "," specs
  fflush file

entry : (PrimIO e , FileIO e) => List String -> App e ()
entry [dir] = do
  let fileTree = unsafePerformIO $ explore $ parse dir
  let allFiles = files $ filter (\fn => "Spec.idr" `isSuffixOf` (fileName fn))
        (\_ => True)
        fileTree
  let specFiles = map fileName allFiles
  let specs = map (\s => fst $ String.break (== '.') s) specFiles
  withFile "\{dir}/Main.idr" WriteTruncate putIOError (mainModule specs)
  withFile "\{dir}/test.ipkg" WriteTruncate putIOError (ipkgTest specs)
entry _ = primIO $ putDoc
  $ annotate bold
  $ annotate (color Red)
  $ "bad usage, try `spec-discover <dir>`"

main : IO ()
main = do
  args <- getArgs
  run $ handle (entry $ drop 1 args) pure putIOError
