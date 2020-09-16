<?php

namespace App\Http\Controllers;

use App\Page;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PageController extends Controller
{
    /**
     * View Pages listing.
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        $pageList = Page::where('user_id', Auth::id())->orderBy('updated_at', 'DESC')->paginate(7);

        return view('page.list', compact('pageList'));
    }

    /**
     * View Create Form.
     *
     * @return \Illuminate\View\View
     */
    public function create()
    {
        return view('page.create');
    }

    /**
     * Create new Page.
     *
     * @param Request $request
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(Request $request)
    {
        $this->validate($request, ['name' => 'required']);

        if($request->get('id')) {
            $page = Page::findOrFail($request->get('id'));

            $page->name = $request->get('name');
            $page->pageText = $request->get('pagetext');
            $page->updated_at = now();
            $page->save();

            return redirect('/page')
                ->with('flash_notification.message', 'Статья отредактированна успешно')
                ->with('flash_notification.level', 'success');
        } else {
            print_r($request->get('pagetext'));
            Page::create([
                'name' => $request->get('name'),
                'user_id' => Auth::user()->id,
                'pageText' =>  $request->get('pagetext')
            ]);

            return redirect('/page')
                ->with('flash_notification.message', 'Статья создана успешно')
                ->with('flash_notification.level', 'success');
        }
    }
    
    /**
     * Toggle Status.
     *
     * @param $id
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update($id)
    {
        $page = Page::findOrFail($id);
        $page->active = !$page->active;
        $page->save();

        return redirect()
            ->route('page.index')
            ->with('flash_notification.message', 'Статус статьи изменена успешно')
            ->with('flash_notification.level', 'success');
    }

    public function edit($id)
    {
        $pageEdit = Page::where('id', $id)->paginate(1);
        return view('page.edit', compact('pageEdit'));
    }


    /**
     * Delete Page.
     *
     * @param $id
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($id)
    {
        $page = Page::findOrFail($id);
        $page->delete();

        return redirect()
            ->route('page.index')
            ->with('flash_notification.message', 'Page deleted successfully')
            ->with('flash_notification.level', 'success');
    }
}
