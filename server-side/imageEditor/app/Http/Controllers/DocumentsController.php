<?php

namespace App\Http\Controllers;

use App\Document;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

use App\Http\Requests;

class DocumentsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));

        if ($user) {
            $data = [];
            $documents = Document::where('user_id', '=', $user->id)->get();

            foreach ($documents as $document)
            {
                $data[] = [
                    'document_id' => $document->id,
                ];
            }

            return json_encode($data);
        }
        else
        {
            return json_encode(['status' => 'User not found']);
        }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));

        if ($user) {
            $document = new Document();
            $document->name = $request->file('document')->getClientOriginalName();

//            $preview_path = $request->file('preview')->store('previews');
//            $document->document_preview_path = $preview_path;
//            $document->document_preview_name = $request->file('preview')->getFilename();
//
//            $document_path = $request->file('document')->store('documents');
            $preview_path = $request->file('preview')->storeAs(
                'previews', str_random(16)
            );
            $document->document_preview_path = $preview_path;
            $document->document_preview_name = $request->file('preview')->getFilename();

            $document_path = $request->file('document')->storeAs(
                'documents', str_random(16)
            );
            $document->document_path = $document_path;
            $document->document_name = $request->file('document')->getFilename();

            $document->user_id = $user->id;

            $document->save();
            return json_encode(['status' => 'Created']);
        }
    }

    public function showName($id, Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));

        if ($user) {
            $document = Document::where('user_id', $user->id)->where('id', $id)->firstOrFail();
            return response($document->name);
        } else {
            return response(['status' => 'User not found'])->setStatusCode(401);
        }
    }

    protected function getUser($token)
    {
        return User::where('token','=', $token)->firstOrFail();
    }



    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id, Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));


    }

    public function showPreview($id, Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));

        if ($user) {
            $document = Document::where('user_id', $user->id)->where('id', $id)->firstOrFail();
            return response(Storage::get($document->document_preview_path))
                ->header('Content-Type', Storage::MimeType($document->document_preview_path));
        } else {
            return json_encode(['status' => 'User not found']);
        }
    }

    public function showDocument($id, Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));

        if ($user) {
            $document = Document::where('user_id', $user->id)->where('id', $id)->firstOrFail();
            return response(Storage::get($document->document_path))
                ->header('Content-Type', Storage::MimeType($document->document_path));
        }
        else {
            return json_encode(['status' => 'User not found']);
        }
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id, Request $request)
    {
        $user = $this->getUser($request->header('Authorization'));

        if ($user) {
            $document = Document::where('user_id', $user->id)->where('id', $id)->firstOrFail();

            Storage::delete([$document->document_preview_path, $document->document_path]);
            $document->delete();
            return json_encode(['status' => 'deleted']);
        }
        else {
            return json_encode(['status' => 'User not found']);
        }
    }
}
